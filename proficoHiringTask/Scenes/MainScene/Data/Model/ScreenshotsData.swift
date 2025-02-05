//
//  Screenshots.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

extension Data {
    struct Screenshots: Decodable {
        let count: Int
        let results: [Screenshot]
    }
}
