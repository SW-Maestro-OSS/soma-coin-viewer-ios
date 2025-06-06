//
//  HTTPService.swift
//  Data
//
//  Created by choijunios on 4/12/25.
//

import Foundation
import Combine

public protocol HTTPService {
    func request<DTO: Decodable>(_ requestBuilder: URLRequestBuilder, dtoType: DTO.Type, retry: Int) async throws -> SuccessResponse<DTO>
    func request<DTO>(_ requestBuilder: URLRequestBuilder, dtoType: DTO.Type) -> Future<SuccessResponse<DTO>, NetworkServiceError> where DTO : Decodable
}

public struct DefaultHTTPService: HTTPService {
    
    private let networkSession: URLSession = .init(configuration: .default)
    private let jsonDecoder: JSONDecoder = .init()
    
    public init() { }
    
    public func request<DTO: Decodable>(_ requestBuilder: URLRequestBuilder, dtoType: DTO.Type, retry: Int = 0) async throws -> SuccessResponse<DTO> {
        guard let request = requestBuilder.build() else {
            throw NetworkServiceError.requestCreationFailed
        }
        do {
            let (data, response) = try await networkSession.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if !(200..<300).contains(statusCode) {
                    // 상태코드가 비정상인 경우
                    let httpError = HTTPResponseException(status: .create(code: statusCode))
                    throw NetworkServiceError.invalidStatusCode(exception: httpError)
                } else {
                    // 상태코드가 정상인 경우
                    var successResponse = SuccessResponse<DTO>()
                    successResponse.set(headers: httpResponse.allHeaderFields)
                    let dto = try jsonDecoder.decode(DTO.self, from: data)
                    successResponse.set(body: dto)
                    return successResponse
                }
            }
            throw NetworkServiceError.unexpectedError(message: "HTTP요청 이외의 다른 용도로 사용됨")
        } catch {
            if retry != 0 {
                let retryRequest = try await self.request(requestBuilder, dtoType: dtoType, retry: retry-1)
                return retryRequest
            } else {
                if error is NetworkServiceError { throw error }
                throw NetworkServiceError.underlying(error: error)
            }
        }
    }
    
    public func request<DTO>(_ requestBuilder: URLRequestBuilder, dtoType: DTO.Type) -> Future<SuccessResponse<DTO>, NetworkServiceError> where DTO : Decodable {
        Future { [weak networkSession] promise in
            guard let request = requestBuilder.build() else {
                return promise(.failure(.requestCreationFailed))
            }
            networkSession?.dataTask(with: request) { data, response, error in
                if let error {
                    promise(.failure(.underlying(error: error)))
                } else {
                    if let httpResponse = response as? HTTPURLResponse {
                        let statusCode = httpResponse.statusCode
                        if !(200..<300).contains(statusCode) {
                            // 상태코드가 비정상인 경우
                            let httpError = HTTPResponseException(status: .create(code: statusCode))
                            promise(.failure(.invalidStatusCode(exception: httpError)))
                        } else {
                            // 상태코드가 정상인 경우
                            var successResponse = SuccessResponse<DTO>()
                            successResponse.set(headers: httpResponse.allHeaderFields)
                            if let data, let dto = try? jsonDecoder.decode(DTO.self, from: data) {
                                // DTO획득에 성공한 경우
                                successResponse.set(body: dto)
                            }
                            promise(.success(successResponse))
                        }
                    }
                }
            }
            .resume()
        }
    }
}
