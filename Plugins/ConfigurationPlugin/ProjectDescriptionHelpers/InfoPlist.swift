//
//  InfoPlist.swift
//  ConfigurationPlugin
//
//

import ProjectDescription

public enum TargetInfoPlist {
    
    public static let main_app: InfoPlist = .extended_app_plist(with: [])
    
    public static let example_app: InfoPlist = .extended_app_plist(with: [])
}

extension InfoPlist {
    
    private static let default_app_plist: [String: ProjectDescription.Plist.Value] = [
        
        "NSAppTransportSecurity" : [
            "NSAllowsArbitraryLoads" : true
        ],
        "UILaunchStoryboardName": "LaunchScreen.storyboard",
        "CFBundleDisplayName" : "$(BUNDLE_DISPLAY_NAME)",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ]
                ]
            ]
        ],
    ]
    
    public static func extended_app_plist(with: [String: ProjectDescription.Plist.Value]) -> InfoPlist {
        
        var resultPlist = default_app_plist
        
        // with 값이 우선되도록
        resultPlist.merge(with) { lhs, rhs in rhs }
        
        return .extendingDefault(with: resultPlist)
    }
}

