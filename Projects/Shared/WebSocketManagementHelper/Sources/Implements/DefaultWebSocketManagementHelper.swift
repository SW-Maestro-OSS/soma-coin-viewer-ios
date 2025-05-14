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

public protocol StreamDecoder {
    func decode(_ stream: WebSocketStream) -> String
}

public class DefaultWebSocketManagementHelper: WebSocketManagementHelper, WebSocketServiceListener {
    
    // Dependency
    private let webSocketService: WebSocketService
    private let streamDecoder: StreamDecoder
    private let alertShootable: AlertShootable
    
    
    // State
    private var currentSubscribtions: Set<String> = []
    private let subscribedStreamManageQueue: DispatchQueue = .init(label: "com.WebSocketManagementHelper")
    private var store: Set<AnyCancellable> = .init()
    
    public init(
        webSocketService: WebSocketService,
        streamDecoder: StreamDecoder,
        alertShootable: AlertShootable
    ) {
        self.webSocketService = webSocketService
        self.streamDecoder = streamDecoder
        self.alertShootable = alertShootable
        
        webSocketService.listener = self
    }
}


// MARK: WebSocketManagementHelper
public extension DefaultWebSocketManagementHelper {
    func requestSubscribeToStream(streams: [WebSocketStream], mustDeliver: Bool) {
        let decodedStreams = streams.map(streamDecoder.decode)
        requestSubscribeToStream(streams: decodedStreams, mustDeliver: mustDeliver)
    }
    
    func requestUnsubscribeToStream(streams: [WebSocketStream], mustDeliver: Bool) {
        let decodedStreams = streams.map(streamDecoder.decode)
        requestUnsubscribeToStream(streams: decodedStreams, mustDeliver: mustDeliver)
    }
    
    func requestDisconnection() {
        webSocketService.disconnect()
    }
    
    func requestConnection(connectionType: ConnectionType) {
        webSocketService.connect { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                if case .recoverPreviousStreams = connectionType {
                    // 구독됬던 스트림 복구 실행
                    recoverPreviouslySubscribedStreams()
                }
            case .failure(let error):
                printIfDebug("\(Self.self) 웹소켓 연결실패 \(error.localizedDescription)")
                var alertModel = AlertModel(
                    titleKey: .alertKey(contents: .title(.webSocketError)),
                    messageKey: .alertKey(contents: .message(.unintendedDisconnection))
                )
                alertModel.add(action: .init(
                    titleKey: .alertKey(contents: .actionTitle(.cancel)),
                    role: .cancel
                ))
                alertModel.add(action: .init(
                    titleKey: .alertKey(contents: .actionTitle(.retry))
                ) { [weak self] in
                    guard let self else { return }
                    requestConnection(connectionType: .recoverPreviousStreams)
                })
                alertShootable.shoot(alertModel)
                return
            }
        }
    }
}


// MARK: Stream subscription
private extension DefaultWebSocketManagementHelper {
    func requestSubscribeToStream(streams: [String], mustDeliver: Bool) {
        subscribedStreamManageQueue.async { [weak self] in
            guard let self else { return }
            // 스트림 구독 메세지 전송
            webSocketService.subscribeTo(message: streams, mustDeliver: mustDeliver) { [weak self] result in
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
                        // 재요청
                        printIfDebug("\(Self.self): 🔄스트림 구독 재요청...")
                        requestSubscribeToStream(streams: streams, mustDeliver: mustDeliver)
                        return
                    default:
                        return
                    }
                }
            }
        }
    }
    
    
    func requestUnsubscribeToStream(streams: [String], mustDeliver: Bool) {
        // 특정스트림에 대해 구독을 해제 메세지 전송
        webSocketService.unsubscribeTo(message: streams, mustDeliver: mustDeliver) { [weak self] result in
            guard let self else { return }
            
            // 리커버리 리스트에서 해당 스트림을 제거
            subscribedStreamManageQueue.async { [weak self] in
                guard let self else { return }
                // 현재 구독중인 스트림에서 구독취소한 스트림 제거
                currentSubscribtions = currentSubscribtions.filter { stream in
                    !streams.contains(stream)
                }
            }
            
            switch result {
            case .success:
                streams.forEach { stream in
                    printIfDebug("\(Self.self): ☑️\(stream)구독 해제 성공")
                }
            case .failure(let error):
                printIfDebug("\(Self.self): 스트림 구독 해제 메세지 전송 실패 \(error.localizedDescription)")
                // 재요청
                printIfDebug("\(Self.self): 🔄스트림 구독 해제 재요청...")
                requestUnsubscribeToStream(streams: streams, mustDeliver: mustDeliver)
            }
        }
    }
}


// MARK: Stream management
private extension DefaultWebSocketManagementHelper {
    /// 스트림을 기록합니다.
    func add(streams: [String]) {
        subscribedStreamManageQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            for stream in streams {
                currentSubscribtions.insert(stream)
            }
        }
    }
    
    /// 스트림을 제거합니다.
    func remove(streams: [String]) {
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
            printIfDebug("[\(Self.self)] 🔄스트림 복구 실행 \(currentSubscribtions)")
            let recoveringStreamList = Array(currentSubscribtions)
            requestSubscribeToStream(streams: recoveringStreamList, mustDeliver: true)
        }
    }
}


// MARK: WebSocketServiceListener
public extension DefaultWebSocketManagementHelper {
    func webSocketListener(unrelatedError error: WebSocketError) {
        switch error {
        case .unintentionalDisconnection(let error):
            printIfDebug("\(Self.self) 비정상적 웹소켓연결 해제 \(error?.localizedDescription ?? "")")
            printIfDebug("\(Self.self): 🔄웹소켓 재연결 요청...")
            requestConnection(connectionType: .recoverPreviousStreams)
            break
        case .internetConnectionError(let error):
            printIfDebug("\(Self.self) 인터넷 연결오류 \(error?.localizedDescription ?? "")")
            var alertModel = AlertModel(
                titleKey: .alertKey(contents: .title(.internetConnectionError)),
                messageKey: .alertKey(contents: .message(.internetConnectionFailed))
                
            )
            alertModel.add(action: .init(
                titleKey: .alertKey(contents: .actionTitle(.cancel)),
                role: .cancel
            ))
            alertModel.add(action: .init(
                titleKey: .alertKey(contents: .actionTitle(.retry))
            ) { [weak self] in
                guard let self else { return }
                requestConnection(connectionType: .recoverPreviousStreams)
            })
            alertShootable.shoot(alertModel)
            break
        case .serverIsBusy, .tooManyRequests:
            var alertModel = AlertModel(
                titleKey: .alertKey(contents: .title(.webSocketError)),
                messageKey: .alertKey(contents: .message(.webSocketServerIsUnstable))
            )
            alertModel.add(action: .init(
                titleKey: .alertKey(contents: .actionTitle(.ignore)),
                role: .cancel
            ))
            alertModel.add(action: .init(
                titleKey: .alertKey(contents: .actionTitle(.retry))
            ) { [weak self] in
                guard let self else { return }
                requestConnection(connectionType: .recoverPreviousStreams)
            })
            alertShootable.shoot(alertModel)
            break
        case .unknown(let error):
            printIfDebug("\(Self.self) 알 수 없는 오류 \(error?.localizedDescription ?? "")")
            var alertModel = AlertModel(
                titleKey: .alertKey(contents: .title(.webSocketError)),
                messageKey: .alertKey(contents: .message(.unknownError))
            )
            alertModel.add(action: .init(
                titleKey: .alertKey(contents: .actionTitle(.cancel))
            ))
            alertShootable.shoot(alertModel)
            break
        default:
            break
        }
    }
}


// MARK: For Test
internal extension DefaultWebSocketManagementHelper {
    @available(*, deprecated, message: "테스트 목적이외에 방식으로 사용되면 안됩니다.")
    func getSavedStreams() -> [String] {
        subscribedStreamManageQueue.sync {
            return Array(currentSubscribtions)
        }
    }
}
