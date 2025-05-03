//
//  URLRequestBuilder.swift
//  Data
//
//  Created by choijunios on 2/4/25.
//

import Foundation

open class URLRequestBuilder {
    // Request configuration
    private let base: URL
    private let httpMethod: HTTPMethod
    private var additionalPaths: [String] = []
    private var attachedBody: Data?
    private var requestHeaders: [String: String] = [:]
    private var queryParams: [URLQueryItem] = []
    
    private let jsonEncoder: JSONEncoder = .init()
    
    public init(base: URL, httpMethod: HTTPMethod) {
        self.base = base
        self.httpMethod = httpMethod
    }
    
    @discardableResult
    public func add(path: String) -> Self {
        additionalPaths.append(path)
        return self
    }
    
    @discardableResult
    public func add(header: [String: String]) -> Self {
        requestHeaders.merge(header) { _, latest in latest }
        return self
    }
    
    @discardableResult
    public func add(queryParam: [String: String]) -> Self {
        let items = queryParam.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        queryParams.append(contentsOf: items)
        return self
    }
    
    @discardableResult
    public func attach(body: any Encodable) throws -> Self {
        self.attachedBody = try jsonEncoder.encode(body)
        return self
    }
    
    public func build() -> URLRequest? {
        var tempURL = base
        // Path
        self.additionalPaths.forEach { path in
            tempURL.appendPathComponent(path)
        }
        
        // Query parameters
        guard var urlComponent = URLComponents(string: tempURL.absoluteString) else { return nil }
        urlComponent.queryItems = self.queryParams
        
        // URLRequest
        guard let endPoint = urlComponent.url else { return nil }
        var urlRequest = URLRequest(url: endPoint)
        
        // Method
        urlRequest.httpMethod = self.httpMethod.httpRequestStr
        
        // Header
        for (key, value) in self.requestHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // body
        urlRequest.httpBody = self.attachedBody
        
        return urlRequest
    }
}
