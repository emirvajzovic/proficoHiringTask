//
//  DeveloperInfo.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

extension Data {
    struct DeveloperInfo: Decodable {
        let id: Int
        let name: String
        let gamesCount: Int
    }
}
