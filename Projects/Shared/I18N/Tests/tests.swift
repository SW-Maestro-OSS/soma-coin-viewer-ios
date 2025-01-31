
import Testing

@testable import I18N
import DomainInterface

struct LocalizableTextRepositoryTest {
    
    @Test
    func checkAllKeysValid() {
        
        // Given
        let repository = DefaultLanguageLocalizationRepository()
        var keys: [String] = []
        keys.append(contentsOf: TextKey.Alert.Title.allCases.map({$0.rawValue}))
        keys.append(contentsOf: TextKey.Alert.Message.allCases.map({$0.rawValue}))
        keys.append(contentsOf: TextKey.Alert.ActionTitle.allCases.map({$0.rawValue}))
        
        
        // When
        let checkingLans: [LanguageType] = [.korean, .english]
        
        
        // Then
        keys.forEach { key in
            checkingLans.forEach { lan in
                _ = repository.getString(key: key, lanCode: lan.lanCode)
            }
        }
        #expect(true)
    }
}
