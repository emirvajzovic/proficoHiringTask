//
//  GenresResponseData.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

extension Data {
    struct GenresResponseData: Decodable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Genre]
    }
}
