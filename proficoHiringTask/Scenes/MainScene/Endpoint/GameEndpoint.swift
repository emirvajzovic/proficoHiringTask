//
//  GameEndpoint.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import Foundation

enum GameEndpoint: Endpoint {
    case games(_ requestData: Data.GamesRequest)
    case gameDetails(_ requestData: Data.GameDetailsRequest)
    case gameScreenshots(_ requestData: Data.GameScreenshotsRequest)
    
    var path: String {
        switch self {
        case .games:
            return "/games"
        case .gameDetails(let requestData):
            return "/games/\(requestData.id)"
        case .gameScreenshots(let requestData):
            return "/games/\(requestData.id)/screenshots"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .games, .gameDetails, .gameScreenshots:
            return .GET
        }
    }
    
    var headers: HTTPHeader? {
        return nil
    }
    
    var parameters: (any Encodable)? {
        switch self {
        case .games(let requestData):
            return requestData
        case .gameDetails:
            return nil
        case .gameScreenshots(let requestData):
            return requestData
        }
    }
    
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return .convertFromSnakeCase
    }
}
