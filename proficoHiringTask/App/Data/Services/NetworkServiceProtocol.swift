//
//  NetworkServiceProtocol.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

protocol NetworkService {
    func request<T: Decodable>(_ request: Endpoint, responseType: T.Type) async throws -> T
}
