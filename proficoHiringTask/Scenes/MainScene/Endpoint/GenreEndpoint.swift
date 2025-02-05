//
//  GenreEndpoint.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import Foundation

enum GenreEndpoint: Endpoint {
    case genres
    
    var path: String {
        switch self {
        case .genres:
            return "/genres"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .genres:
            return .GET
        }
    }
    
    var headers: HTTPHeader? {
        return nil
    }
    
    var parameters: (any Encodable)? {
        switch self {
        case .genres:
            return nil
        }
    }
    
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return .convertFromSnakeCase
    }
}
