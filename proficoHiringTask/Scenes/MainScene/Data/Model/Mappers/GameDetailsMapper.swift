//
//  GameDetailsMapper.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

struct GameDetailsMapper {
    static func map(from gameDetails: Data.GameDetails) -> Domain.GameDetails {
        let platforms = PlatformsMapper.map(from: gameDetails.platforms)
        let parentPlatforms = PlatformsMapper.map(from: gameDetails.parentPlatforms)
        let genres = GenresMapper.map(from: gameDetails.genres)
        let developers = DeveloperInfoMapper.map(from: gameDetails.developers)
        let publishers = DeveloperInfoMapper.map(from: gameDetails.publishers)
        let esrbRating = EsrbRatingMapper.map(from: gameDetails.esrbRating)
        
        return .init(id: gameDetails.id,
                     name: gameDetails.name ?? .init(),
                     backgroundImage: gameDetails.backgroundImage ?? .init(),
                     platforms: platforms,
                     parentPlatforms: parentPlatforms,
                     genres: genres,
                     released: gameDetails.released ?? .init(),
                     description: gameDetails.descriptionRaw ?? .init(),
                     developers: developers,
                     publishers: publishers,
                     esrbRating: esrbRating)
    }
}
