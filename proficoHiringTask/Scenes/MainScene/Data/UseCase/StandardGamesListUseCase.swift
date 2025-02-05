//
//  GamesListUseCase.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

import Combine

final class StandardGamesListUseCase: GamesListUseCase {
    @Injected private var repository: GamesRepository
    @Injected private var preferencesRepository: PreferencesRepository
    
    var dataPublisher: AnyPublisher<[Int], Never>? {
        preferencesRepository.dataPublisher.eraseToAnyPublisher()
    }
    
    func execute(page: Int, pageSize: Int) async throws -> [Domain.Game] {
        let genres = try? preferencesRepository.getFavoriteGenres()
        return try await repository.getGames(page: page, pageSize: pageSize, genres: genres)
    }
}
