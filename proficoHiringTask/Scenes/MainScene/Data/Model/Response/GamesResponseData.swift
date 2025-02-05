//
//  GamesResponse.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 31. 1. 2025..
//

extension Data {
    struct GamesResponse: Decodable {
        var count: Int
        var next: String?
        var previous: String?
        var results: [Game]
    }
}
