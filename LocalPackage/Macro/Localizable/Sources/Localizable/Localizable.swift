// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: arbitrary)
public macro I18NRepresentable<T>(table: String, bundleClass: T.Type) = #externalMacro(module: "LocalizableMacros", type: "I18NRepresentable")
