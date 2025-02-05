//
//  GenresMapper.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

struct GenresMapper {
    static func map(from genre: Data.Genre) -> Domain.Genre {
        return .init(id: genre.id,
                     name: genre.name,
                     slug: genre.slug,
                     gamesCount: genre.gamesCount,
                     imageBackground: genre.imageBackground)
    }
    
    static func map(from genres: [Data.Genre]?) -> [Domain.Genre] {
        guard let genres else { return [] }
        return genres.map { map(from: $0) }
    }
}
