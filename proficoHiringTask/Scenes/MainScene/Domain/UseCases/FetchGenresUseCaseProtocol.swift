//
//  GenresUseCaseProtocol.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

protocol FetchGenresUseCase {
    func execute() async throws -> [Domain.Genre]
}
