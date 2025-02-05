//
//  NetworkRequest.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeader? { get }
    var parameters: Encodable? { get }
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
    func asURLRequest() throws -> URLRequest
}

extension Endpoint {
    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(string: APIConfig.baseUrl + path)
        
        if let parameters,
           let encodedData = try? JSONEncoder().encode(parameters),
           let parameters = try? JSONSerialization.jsonObject(with: encodedData) as? [String: Any] {
            var queryItems = urlComponents?.queryItems ?? []
            let newQueryItems = parameters.compactMap {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
            queryItems.append(contentsOf: newQueryItems)
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
