//
//  RawgGame.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 31. 1. 2025..
//

extension Data {
    struct Game: Decodable {
        let id: Int
        let name: String?
        let backgroundImage: String?
        let parentPlatforms: [Platforms]?
        let genres: [Genre]?
    }
}
