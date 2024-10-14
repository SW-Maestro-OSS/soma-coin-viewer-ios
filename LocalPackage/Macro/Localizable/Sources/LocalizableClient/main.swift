import Localizable
import Foundation

class TestClass { }

@I18NRepresentable(table: "MainPage", bundleClass: TestClass.self)
enum TestEnum {
    
    case first
    case second
}


