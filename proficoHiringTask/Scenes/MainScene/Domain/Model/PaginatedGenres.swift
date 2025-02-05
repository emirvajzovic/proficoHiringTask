//
//  PaginatedGenres.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

extension Domain {
    struct PaginatedGenres {
        var pagination: Pagination
        var genres: [Genre]
    }
}
