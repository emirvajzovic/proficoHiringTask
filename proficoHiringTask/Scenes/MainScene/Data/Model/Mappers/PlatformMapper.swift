//
//  PlatformMapper.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

struct PlatformMapper {
    static func map(from platform: Data.Platform) -> Domain.Platform {
        return .init(id: platform.id, name: platform.name, slug: platform.slug)
    }
}
