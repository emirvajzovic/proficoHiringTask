//
//  GenrePresentation.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

extension Presentation {
    struct Genre: Hashable {
        let id: Int
        let name: String
        let backgroundImage: String?
        let selected: Bool
    }
}
