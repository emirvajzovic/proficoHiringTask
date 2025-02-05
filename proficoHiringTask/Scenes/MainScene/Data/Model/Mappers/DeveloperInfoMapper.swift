//
//  DeveloperInfoMapper.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

struct DeveloperInfoMapper {
    static func map(from developerInfo: Data.DeveloperInfo) -> Domain.DeveloperInfo {
        return .init(id: developerInfo.id,
                     name: developerInfo.name,
                     gamesCount: developerInfo.gamesCount)
    }
    
    static func map(from developerInfos: [Data.DeveloperInfo]?) -> [Domain.DeveloperInfo] {
        guard let developerInfos else { return [] }
        return developerInfos.map { map(from: $0) }
    }
}
