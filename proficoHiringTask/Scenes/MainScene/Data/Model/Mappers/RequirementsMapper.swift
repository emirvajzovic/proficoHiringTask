//
//  RequirementsMapper.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

struct RequirementsMapper {
    static func map(from requirements: Data.SystemRequirements?) -> Domain.SystemRequirements? {
        guard let requirements else { return nil }
        return .init(minimum: requirements.minimum,
                     recommended: requirements.recommended)
    }
}
