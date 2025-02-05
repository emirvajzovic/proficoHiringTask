//
//  GamePresentation.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

extension Presentation {
    struct Game: Hashable {
        let id: Int
        let name: String
        let backgroundImage: String
        let platforms: [Int]
        let genres: [String]
    }
}
