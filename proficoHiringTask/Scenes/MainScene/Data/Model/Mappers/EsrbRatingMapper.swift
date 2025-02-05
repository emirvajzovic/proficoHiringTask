//
//  EsrbRatingMapper.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

struct EsrbRatingMapper {
    static func map(from esrbRating: Data.EsrbRating?) -> Domain.EsrbRating? {
        guard let esrbRating else { return nil }
        return .init(id: esrbRating.id, name: esrbRating.name)
    }
}
