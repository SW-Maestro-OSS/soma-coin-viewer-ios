import XCTest
@testable import App  // 테스트하려는 모듈을 가져오기

class AppTests: XCTestCase {

    override func setUpWithError() throws {
        // 테스트 시작 전 초기화 코드
    }

    override func tearDownWithError() throws {
        // 테스트 종료 후 정리 코드
    }

    func testExample() throws {
        // 예시 테스트
        XCTAssertEqual(1 + 1, 2)
    }
}

