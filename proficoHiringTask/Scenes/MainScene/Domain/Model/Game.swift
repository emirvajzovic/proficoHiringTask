//
//  Game.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 31. 1. 2025..
//

extension Domain {
    struct Game {
        let id: Int
        let name: String
        let backgroundImage: String
        let parentPlatforms: [Platforms]
        let genres: [Genre]
    }
}
