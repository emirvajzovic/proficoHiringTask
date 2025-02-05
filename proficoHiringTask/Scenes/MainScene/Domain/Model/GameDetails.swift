//
//  GameDetails.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

extension Domain {
    struct GameDetails {
        let id: Int
        let name: String
        let backgroundImage: String
        let platforms: [Platforms]
        let parentPlatforms: [Platforms]
        let genres: [Genre]
        let released: String
        let description: String
        let developers: [DeveloperInfo]
        let publishers: [DeveloperInfo]
        let esrbRating: EsrbRating?
    }
}
