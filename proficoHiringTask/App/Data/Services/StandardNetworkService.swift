//
//  StandardNetworkService.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

final class StandardNetworkService: NetworkService {
    private static var adapters: [RequestAdapter] {
        [APIKeyAdapter()]
    }
    private let service = CoreNetworkService(adapters: adapters)
    
    func request<T>(_ request: any Endpoint, responseType: T.Type) async throws -> T where T : Decodable {
        try await service.request(request, responseType: responseType)
    }
}
