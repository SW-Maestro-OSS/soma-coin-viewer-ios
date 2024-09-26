import XCTest
@testable import DataSource

class WebSocketServiceTests: XCTestCase {

    var webSocketService: DefaultWebSocketService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        webSocketService = DefaultWebSocketService()
    }

    override func tearDownWithError() throws {
        webSocketService = nil
        try super.tearDownWithError()
    }

    func testWebSocketConnectAndDisconnect() throws {
        
        // Expectation for WebSocket connection
        let connectExpectation = expectation(description: "WebSocket should connect successfully")
        let disconnectExpectation = expectation(description: "WebSocket should disconnect successfully")
        
        let testURL = URL(string: "wss://stream.binance.com:443/stream")!

        // 웹소켓 연결 테스트
        webSocketService.connect(to: testURL, streams: ["btcusdt@trade"]) { message in
            switch message {
            case .string(let text):
                print("Received message: \(text)")
            case .data(let data):
                print("Received data: \(data)")
            @unknown default:
                XCTFail("Unexpected message type")
            }
        }
        
        // WebSocket 연결 이벤트를 수신 대기
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 연결이 성공했다면
            if self.webSocketService.task?.state == .running {
                connectExpectation.fulfill()
            } else {
                XCTFail("웹소켓 연결 실패")
            }
        }
        
        // 2초 후에 연결 해제 테스트
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.webSocketService.disconnect()
            
            // WebSocket 해제 이벤트 대기
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if self.webSocketService.task?.state == .canceling || self.webSocketService.task?.state == .completed {
                    disconnectExpectation.fulfill()
                } else {
                    XCTFail("웹소켓 연결 해제 실패")
                }
            }
        }
        
        // Test timeouts
        wait(for: [connectExpectation, disconnectExpectation], timeout: 10.0)
    }
}
