//
//  NetworkError.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//


enum NetworkError: Error {
    case invalidRequest
    case invalidURL
    case invalidResponse
    case decodingError(_ error: Error)
    case clientError(_ statusCode: Int)
    case serverError(_ statusCode: Int)
    case unknown(_ statusCode: Int)
    case requestFailed(_ description: Error)
}
