//
//  InfoPlist.swift
//  ConfigurationPlugin
//
//

import ProjectDescription

public extension InfoPlist {
    
    static let main_app: InfoPlist = .extended_app_plist(with: [:])
    
    static let example_app: InfoPlist = .extended_app_plist(with: [:])
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

