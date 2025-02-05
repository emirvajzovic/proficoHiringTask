//
//  PlatformsResponseData.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

extension Data {
    struct Platforms: Decodable {
        let platform: Platform
        let releasedAt: String?
        let requirements: SystemRequirements?
    }
}
