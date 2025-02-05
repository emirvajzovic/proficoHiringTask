//
//  GameMapper.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

struct GameMapper {
    static func map(from game: Data.Game) -> Domain.Game {
        return .init(id: game.id,
                     name: game.name ?? .init(),
                     backgroundImage: game.backgroundImage ?? .init(),
                     parentPlatforms: PlatformsMapper.map(from: game.parentPlatforms ?? []),
                     genres: GenresMapper.map(from: game.genres ?? []))
    }
}
