//
//  GameDetails.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

extension Data {
    struct GameDetails: Decodable {
        let id: Int
        let name: String?
        let backgroundImage: String?
        let platforms: [Platforms]?
        let parentPlatforms: [Platforms]?
        let genres: [Genre]?
        let released: String?
        let descriptionRaw: String?
        let website: String?
        let rating: Double?
        let developers: [DeveloperInfo]?
        let publishers: [DeveloperInfo]?
        let esrbRating: EsrbRating?
        let screenshotsCount: Int?
    }
}
