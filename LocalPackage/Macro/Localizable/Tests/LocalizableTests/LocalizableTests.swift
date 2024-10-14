import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Localizable


class TestClass { }

@I18NRepresentable(table: "MainPage", bundleClass: TestClass.self)
enum TestEnum {
    
    case first
    case second
}


final class LocalizableTests: XCTestCase {
    
    func testLocalizableMacro() {
        
    }
}
