//
//  FetchGameDetailsUseCase.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

protocol FetchGameDetailsUseCase {
    func execute(gameId: Int) async throws -> Domain.GameDetails
}
