//
//  NetworkClient.swift
//  FlickrSearch
//
//  Created by Attila Tamas on 20.06.2022.
//

import Foundation
import Alamofire

public enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"

    var afMethod: Alamofire.HTTPMethod {
        switch self {
        case .get: return .get
        case .head: return .head
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        case .patch: return .patch
        }
    }
}

struct APIConfiguration: NetworkClientConfiguration {
    let baseUrl: String
    let jsonEncoder: JSONEncoder = .init()
    let jsonDecoder: JSONDecoder = .init()

    init(baseUrl: String) {
        self.baseUrl = baseUrl
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.dateDecodingStrategy = .iso8601
    }
}

/// This protocol represents a backend server configuration.
public protocol NetworkClientConfiguration {
    /// The base URL of the backend service
    var baseUrl: String { get }
    /// JSON encoder
    var jsonEncoder: JSONEncoder { get }
    /// JSON decoder
    var jsonDecoder: JSONDecoder { get }
}

public class NetworkClient {
    
    private let config: NetworkClientConfiguration
    private let session: Alamofire.Session
    
    public init(config: NetworkClientConfiguration, session: Alamofire.Session = .default) {
        self.config = config
        self.session = session
    }
    
    // Different parameter type overrides
    
    public func execute(
        method: HTTPMethod = .get,
        path: String = "/"
    ) async throws {
        let _: Empty = try await _execute(method: method, path: path, data: Empty.value)
    }
    
    public func execute<Response: Decodable>(
        method: HTTPMethod = .get,
        path: String = "/"
    ) async throws -> Response {
        return try await _execute(method: method, path: path, data: Empty.value)
    }
    
    public func execute<RequestData: Encodable>(
        method: HTTPMethod = .get,
        path: String = "/",
        data: RequestData
    ) async throws {
        let _: Empty = try await _execute(method: method, path: path, data: data)
    }
    
    public func execute<RequestData: Encodable, Response: Decodable>(
        method: HTTPMethod = .get,
        path: String = "/",
        data: RequestData
    ) async throws -> Response {
        return try await _execute(method: method, path: path, data: data)
    }
    
    // MARK: - Private
    func requestData<Data: Encodable>(path: String, data: Data? = nil) async throws -> Foundation.Data {
        let request = session.request(config.baseUrl + path,
                                      method: .get,
                                      parameters: data,
                                      encoder:  URLEncodedFormParameterEncoder.default,
                                      headers: [
                                        HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"),
                                        HTTPHeader(name: "Accept", value: "application/*")
                                      ])

        return try await withCheckedThrowingContinuation { continuation in
            request.validate().responseData { response in
                switch response.result {
                case .failure(let error):
                    debugPrint(error)
                    continuation.resume(throwing: error)
                case .success(let data):
                    continuation.resume(with: .success(data))
                }
            }
        }
    }

    private func _execute<Data: Encodable, Response: Decodable>(method: HTTPMethod, path: String, data: Data? = nil) async throws -> Response {
        let acceptValue: String = method == .put ? "*/*" : "application/json"
        let request = session.request(config.baseUrl + path,
                                      method: method.afMethod,
                                      parameters: data,
                                      encoder: method == .get ? URLEncodedFormParameterEncoder.default : JSONParameterEncoder.default,
                                      headers: [
                                        HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"),
                                        HTTPHeader(name: "Accept", value: acceptValue)
                                      ])
        
        return try await withCheckedThrowingContinuation { continuation in
            request.validate().responseDecodable(of: Response.self, decoder: config.jsonDecoder) { response in
                switch response.result {
                case .failure(let error):
                    // Send useful deserialization logging to the debug console
                    debugPrint(error)
                    continuation.resume(throwing: error)
                case .success(let data):
                    continuation.resume(with: .success(data))
                }
            }
        }
    }
}
