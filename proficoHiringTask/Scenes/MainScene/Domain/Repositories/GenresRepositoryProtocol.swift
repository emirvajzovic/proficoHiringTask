//
//  GenresRepositoryProtocol.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

protocol GenresRepository {
    func getGenres() async throws -> Domain.PaginatedGenres
}
