//
//  RawgGame.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 31. 1. 2025..
//

extension Data {
    struct Genre: Decodable {
        var id: Int
        var name: String
        var slug: String
        var gamesCount: Int?
        var imageBackground: String?
    }
}
