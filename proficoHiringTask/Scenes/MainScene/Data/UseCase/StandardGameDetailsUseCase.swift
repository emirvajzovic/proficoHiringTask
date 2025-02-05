//
//  StandardGameDetailsUseCase.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

final class StandardGameDetailsUseCase: GameDetailsUseCase {
    @Injected private var repository: GamesRepository
    
    func getDetails(gameId: Int) async throws -> Domain.GameDetails {
        return try await repository.getGameDetails(id: gameId)
    }
    
    func getScreenshots(gameId: Int, count: Int) async throws -> [Domain.Screenshot] {
        return try await repository.getGameScreenshots(id: gameId, count: count)
    }
}
