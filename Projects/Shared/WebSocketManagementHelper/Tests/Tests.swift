//
//  Tests.swift
//  WebSocketManagementHelper
//
//  Created by choijunios on 1/24/25.
//

import Testing
import Combine

@testable import WebSocketManagementHelper
@testable import WebSocketManagementHelperTesting

struct WebSocketManagementHelperTests {
    
    @Test
    func checkStreamSavingWhenSubscriptionSucceed() async {
        
        // MARK: 구독 성공시 스트림이 저장되는 확인한다.
        
        // Given
        // - 모든 응답에 대해 항상성공을 반환하는 Stub WebSocketService
        let webSocketHelper = DefaultWebSocketManagementHelper(
            webSocketService: StubAllwaysSuccessWebSocketService(),
            alertShooter: FakeAlertShooter()
        )
        
        
        // When
        let testStreams = ["test1", "test2", "test3", "test4"]
        webSocketHelper.requestSubscribeToStream(streams: testStreams)
        try? await Task.sleep(for: .seconds(3))
        
        
        // Then
        let savedStreams = webSocketHelper.getSavedStreams().sorted()
        let expectedStreams = testStreams.sorted()
        #expect(savedStreams == expectedStreams)
    }
    
    
    @Test
    func checkStreamSavingWhenSubscriptionFailed() async {
        
        // MARK: 구독 실패시 스트림이 저장되지 않고 무시되는지 확인한다.
        
        // Given
        // - 모든 응답에 대해 항상실패를 반환하는 Stub WebSocketService
        let webSocketHelper = DefaultWebSocketManagementHelper(
            webSocketService: StubAllwaysFailureWebSocketService(),
            alertShooter: FakeAlertShooter()
        )
        
        
        // When
        let testStreams = ["test1", "test2", "test3", "test4"]
        webSocketHelper.requestSubscribeToStream(streams: testStreams)
        try? await Task.sleep(for: .seconds(3))
        
        
        // Then
        let savedStreams = webSocketHelper.getSavedStreams()
        #expect(savedStreams.isEmpty)
    }
    
    
    @Test
    func checkShootAlertWhenUnSubscribtionFailed() async {
        
        // Given
        let alertShooter = FakeAlertShooter()
        let webSocketHelper = DefaultWebSocketManagementHelper(
            webSocketService: StubAllwaysFailureWebSocketService(),
            alertShooter: alertShooter
        )
        
        // When
        webSocketHelper.requestUnsubscribeToStream(streams: ["Test"])
        try? await Task.sleep(for: .seconds(3))
        
        
        // Then
        #expect(alertShooter.shotAlertModels.isEmpty == false)
    }
}
