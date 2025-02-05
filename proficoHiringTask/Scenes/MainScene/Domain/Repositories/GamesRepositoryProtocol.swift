//
//  RawgRepositoryProtocol.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

protocol GamesRepository {
    func getGames(page: Int, pageSize: Int, genres: [Int]?) async throws -> [Domain.Game]
    func getGameDetails(id: Int) async throws -> Domain.GameDetails
    func getGameScreenshots(id: Int, count: Int) async throws -> [Domain.Screenshot]
}
