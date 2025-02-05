//
//  GameDetailsPresentation.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

extension Presentation {
    struct GameDetails {
        let description: String
        let platforms: [String]
        let requirements: [PlatformRequirements]
        let genres: [String]
        let releaseDate: String
        let developers: [String]
        let publishers: [String]
        let esrbRating: String?
        let screenshots: [String]
    }
}
