import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct I18NRepresentable: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            
            return []
        }
        
        
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self),
              let tableArgument = arguments.first(where: { $0.label?.text == "table" })?.expression.as(StringLiteralExprSyntax.self),
              let bundleClassExpression = arguments.first(where: { $0.label?.text == "bundleClass" })?.expression
        
        else {
            return []
        }
        
        var members: [DeclSyntax] = []
        
        members.append("""
        public var str: String {
            switch self {
        """)

        var cases: [DeclSyntax] = []
        
        // Enum의 각 케이스에 대해 변수를 생성, 전달된 prefix를 붙임
        for caseElement in enumDecl.memberBlock.members.compactMap({ $0.decl.as(EnumCaseDeclSyntax.self) }) {
            
            // case first, second, third 구조 때문에 2중 for문
            for element in caseElement.elements {
                let varName = element.name.text
                
                
                cases.append("""
                case .\(raw: varName):
                    String(localized: "\(raw: varName)\", table: \(tableArgument), bundle: Bundle(for: \(raw: bundleClassExpression)))
                """)
            }
        }
        members.append(contentsOf: cases)
        
        members.append("""
            }
        }
        """)

        return members
    }
}

@main
struct I18NMacroPlugin: CompilerPlugin {
    
    let providingMacros: [any Macro.Type] = [
        I18NRepresentable.self
    ]
}

