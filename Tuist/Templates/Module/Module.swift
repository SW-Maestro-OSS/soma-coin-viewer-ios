//
//  Module.swift
//
//

import Foundation
import ProjectDescription

private let name: Template.Attribute = .required("name")
private let author: Template.Attribute = .required("author")
private let currentDate: Template.Attribute = .required("currentDate")

let projectPath = "Projects/Features/\(name)"

let featureTemplate = Template(
    description: "A template for a new feature module",
    attributes: [
        name,
        author,
        currentDate
    ],
    items: [
        
        // Example
        
        .item(path: "\(projectPath)/Example", contents: .directory(.relativeToRoot("Scaffold/TMA/Example/Sources"))),
        
        .item(path: "\(projectPath)/Example", contents: .directory(.relativeToRoot("Scaffold/TMA/Example/Resources"))),
        
        
        // Tests
        
        .item(path: "\(projectPath)/Tests/Tests.swift", contents: .file(.relativeToRoot("Scaffold/TMA/Tests/Tests.swift"))),
        
        
        // Feature
        
        .item(path: "\(projectPath)/Feature", contents: .directory(.relativeToRoot("Scaffold/TMA/Feature/Sources"))),
            
        .item(path: "\(projectPath)/Feature", contents: .directory(.relativeToRoot("Scaffold/TMA/Feature/Resources"))),
        
        
        // Testing
        
        .item(path: "\(projectPath)/Testing/Testing.swift", contents: .file(.relativeToRoot("Scaffold/TMA/Testing/Testing.swift"))),
        
        
        // Project.swift
        
        .file(
            path: "\(projectPath)/Project.swift",
            templatePath: .relativeToRoot("Scaffold/TMA/Project.stencil")
        ),
    ]
)
