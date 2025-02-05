//
//  PlatformsMapper.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

struct PlatformsMapper {
    static func map(from platforms: Data.Platforms) -> Domain.Platforms {
        return .init(platform: PlatformMapper.map(from: platforms.platform),
                     releasedAt: platforms.releasedAt,
                     requirements: RequirementsMapper.map(from: platforms.requirements))
    }
    
    static func map(from platforms: [Data.Platforms]?) -> [Domain.Platforms] {
        guard let platforms else { return [] }
        return platforms.map { map(from: $0) }
    }
}
