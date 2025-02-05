//
//  StandardFetchGameDetailsUseCase.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

final class StandardFetchGameDetailsUseCase: FetchGameDetailsUseCase {
    @Injected private var repository: GamesRepository
    
    func execute(gameId: Int) async throws -> Domain.GameDetails {
        return try await repository.getGameDetails(id: gameId)
    }
}
