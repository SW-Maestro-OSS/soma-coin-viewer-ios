//
//  DefaultWebSocketManagementHelper.swift
//
//

import Foundation
import Combine

import DataSource

import I18N
import AlertShooter
import CoreUtil

public class DefaultWebSocketManagementHelper: WebSocketManagementHelper, WebSocketServiceListener {
    
    // Dependency
    private let webSocketService: WebSocketService
    private let alertShooter: AlertShooter
    
    
    // Stream
    public typealias Stream = String
    
    
    // Pulbic interface
    public private(set) var isWebSocketConnected: AnyPublisher<Bool, Never> = Empty().eraseToAnyPublisher()
    
    
    private var currentSubscribtions: Set<Stream> = []
    private let subscribedStreamManageQueue: DispatchQueue = .init(label: "com.WebSocketManagementHelper")
    private var store: Set<AnyCancellable> = .init()
    
    public init(webSocketService: WebSocketService, alertShooter: AlertShooter) {
        self.webSocketService = webSocketService
        self.alertShooter = alertShooter
        
        webSocketService.listener = self
    }
    
    
    public func requestSubscribeToStream(streams: [Stream]) {
        subscribedStreamManageQueue.async { [weak self] in
            guard let self else { return }
            // 스트림 구독 메세지 전송
            webSocketService.subscribeTo(message: streams) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    streams.forEach { stream in
                        printIfDebug("\(Self.self): ✅\(stream)구독 성공")
                    }
                    // 구독에 성공한 스트림들을 기록합니다.
                    add(streams: streams)
                case .failure(let webSocketError):
                    switch webSocketError {
                    case .messageTransferFailed(_):
                        streams.forEach { stream in
                            printIfDebug("\(Self.self): ❌\(stream)구독 실패")
                        }
                    
                        var alertModel = AlertModel(
                            titleKey: TextKey.Alert.Title.webSocketError.rawValue,
                            messageKey: TextKey.Alert.Message.streamSubFailure.rawValue
                        )
                        alertModel
                            .add(action: .init(
                                titleKey: TextKey.Alert.ActionTitle.cancel.rawValue,
                                config: .init(textColor: .red)
                            ))
                        alertModel.add(action: .init(
                            titleKey: TextKey.Alert.ActionTitle.retry.rawValue,
                            action: { [weak self] in
                                guard let self else { return }
                                requestSubscribeToStream(streams: streams)
                            })
                        )
                        alertShooter.shoot(alertModel)
                        
                        return
                    default:
                        return
                    }
                }
            }
        }
    }
    
    
    public func requestUnsubscribeToStream(streams willRemoveStreams: [Stream]) {
        
        // 특정스트림에 대해 구독을 해제 메세지 전송
        webSocketService.unsubscribeTo(message: willRemoveStreams) { [weak self] result in
                       
            guard let self else { return }
            
            // 리커버리 리스트에서 해당 스트림을 제거
            subscribedStreamManageQueue.async { [weak self] in
                guard let self else { return }
                // 현재 구독중인 스트림에서 구독취소한 스트림 제거
                currentSubscribtions = currentSubscribtions.filter { stream in
                    !willRemoveStreams.contains(stream)
                }
            }
            
            if case .failure(let error) = result {
                printIfDebug("\(Self.self): 스트림 구독 해제 메세지 전송 실패 \(error.localizedDescription)")
                
                var alertModel = AlertModel(
                    titleKey: TextKey.Alert.Title.webSocketError.rawValue,
                    messageKey: TextKey.Alert.Message.streamUnsubFailure.rawValue
                )
                alertModel.add(action: .init(
                    titleKey: TextKey.Alert.ActionTitle.ignore.rawValue,
                    config: .init(textColor: .red)
                ))
                alertModel.add(action: .init(
                    titleKey: TextKey.Alert.ActionTitle.retry.rawValue
                ) { [weak self] in
                    guard let self else { return }
                    requestUnsubscribeToStream(streams: willRemoveStreams)
                })
                alertShooter.shoot(alertModel)
            }
        }
    }
    
    
    public func requestDisconnection() {
        webSocketService.disconnect()
    }
    
    
    public func requestConnection(connectionType: ConnectionType) {
        webSocketService.connect { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                if case .recoverPreviousStreams = connectionType {
                    // 구독됬던 스트림 복구 실행
                    recoverPreviouslySubscribedStreams()
                }
            case .failure(let error):
                // MARK: 웹소켓 연결 실패 대처
                printIfDebug("\(Self.self) 웹소켓 연결실패 \(error.localizedDescription)")
                return
            }
        }
    }
}

private extension DefaultWebSocketManagementHelper {
    
    /// 스트림을 기록합니다.
    func add(streams: [Stream]) {
        subscribedStreamManageQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            for stream in streams {
                currentSubscribtions.insert(stream)
            }
        }
    }
    
    
    /// 스트림을 제거합니다.
    func remove(streams: [Stream]) {
        subscribedStreamManageQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            for stream in streams {
                if let index = currentSubscribtions.firstIndex(of: stream) {
                    currentSubscribtions.remove(at: index)
                }
            }
        }
    }
    
    
    func recoverPreviouslySubscribedStreams() {
        subscribedStreamManageQueue.async { [weak self] in
            guard let self else { return }
            printIfDebug("\(Self.self) 스트림 복구 실행 \(currentSubscribtions)")
            let recoveringStreamList = Array(currentSubscribtions)
            self.requestSubscribeToStream(streams: recoveringStreamList)
        }
    }
}


// MARK: For Test
internal extension DefaultWebSocketManagementHelper {
    
    @available(*, deprecated, message: "테스트 목적이외에 방식으로 사용되면 안됩니다.")
    func getSavedStreams() -> [Stream] {
        subscribedStreamManageQueue.sync {
            return Array(currentSubscribtions)
        }
    }
}


// MARK: WebSocketServiceListener
public extension DefaultWebSocketManagementHelper {
    func webSocketListener(unrelatedError error: WebSocketError) {
        switch error {
        case .unintentionalDisconnection(let error):
            printIfDebug("\(Self.self) 비정상적 웹소켓연결 해제 \(error?.localizedDescription ?? "")")
            var alertModel = AlertModel(
                titleKey: TextKey.Alert.Title.webSocketError.rawValue,
                messageKey: TextKey.Alert.Message.unintendedDisconnection.rawValue
            )
            alertModel.add(action: .init(
                titleKey: TextKey.Alert.ActionTitle.cancel.rawValue,
                config: .init(textColor: .red)
            ))
            alertModel.add(action: .init(
                titleKey: TextKey.Alert.ActionTitle.retry.rawValue
            ) { [weak self] in
                guard let self else { return }
                requestConnection(connectionType: .recoverPreviousStreams)
            })
            alertShooter.shoot(alertModel)
            break
        case .internetConnectionError(let error):
            var alertModel = AlertModel(
                titleKey: TextKey.Alert.Title.internetConnectionError.rawValue,
                messageKey: TextKey.Alert.Message.internetConnectionFailed.rawValue
            )
            alertModel.add(action: .init(
                titleKey: TextKey.Alert.ActionTitle.cancel.rawValue,
                config: .init(textColor: .red)
            ))
            alertModel.add(action: .init(
                titleKey: TextKey.Alert.ActionTitle.retry.rawValue
            ) { [weak self] in
                guard let self else { return }
                requestConnection(connectionType: .recoverPreviousStreams)
            })
            alertShooter.shoot(alertModel)
            break
        case .serverIsBusy, .tooManyRequests:
            var alertModel = AlertModel(
                titleKey: TextKey.Alert.Title.webSocketError.rawValue,
                messageKey: TextKey.Alert.Message.webSocketServerIsUnstable.rawValue
            )
            alertModel.add(action: .init(
                titleKey: TextKey.Alert.ActionTitle.ignore.rawValue,
                config: .init(textColor: .red)
            ))
            alertModel.add(action: .init(
                titleKey: TextKey.Alert.ActionTitle.retry.rawValue
            ) { [weak self] in
                guard let self else { return }
                requestConnection(connectionType: .recoverPreviousStreams)
            })
            alertShooter.shoot(alertModel)
            break
        case .unknown(let error):
            var alertModel = AlertModel(
                titleKey: TextKey.Alert.Title.webSocketError.rawValue,
                messageKey: TextKey.Alert.Message.unknownError.rawValue
            )
            alertModel.add(action: .init(
                titleKey: TextKey.Alert.ActionTitle.cancel.rawValue
            ))
            alertShooter.shoot(alertModel)
            break
        default:
            break
        }
    }
}
