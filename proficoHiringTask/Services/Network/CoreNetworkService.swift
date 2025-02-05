//
//  CoreNetworkService.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 31. 1. 2025..
//

import Foundation

open class CoreNetworkService {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let adapters: [RequestAdapter]
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init(), adapters: [RequestAdapter] = []) {
        self.session = session
        self.decoder = decoder
        self.adapters = adapters
    }
    
    func request<T: Decodable>(_ request: Endpoint, responseType: T.Type) async throws -> T {
        decoder.keyDecodingStrategy = request.keyDecodingStrategy
        guard var urlRequest = try? request.asURLRequest() else {
            throw NetworkError.invalidRequest
        }
        
        for adapter in adapters {
            adapter.adapt(&urlRequest)
        }
        
#if DEBUG
        print("📲 Request: \(urlRequest.httpMethod ?? "UNKNOWN") \(urlRequest.url?.absoluteString ?? "NO URL")")
#endif
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try decoder.decode(T.self, from: data)
            } catch(let error) {
                throw NetworkError.decodingError(error)
            }
        case 400...499:
            throw NetworkError.clientError(httpResponse.statusCode)
        case 500...599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.unknown(httpResponse.statusCode)
        }
    }
}
