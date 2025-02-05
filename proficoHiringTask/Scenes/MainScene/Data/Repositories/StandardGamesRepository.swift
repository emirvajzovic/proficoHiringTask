//
//  StandardGamesRepository.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

final class StandardGamesRepository: GamesRepository {
    @Injected private var networkService: NetworkService
    
    func getGames(page: Int, pageSize: Int, genres: [Int]?) async throws -> [Domain.Game] {
        let requestData = Data.GamesRequest(page: page, pageSize: pageSize, genres: genres)
        let response = try await networkService.request(
            GameEndpoint.games(requestData),
            responseType: Data.GamesResponse.self
        )
        let games = response.results.map { GameMapper.map(from: $0) }
        
        return games
    }
    
    func getGameDetails(id: Int) async throws -> Domain.GameDetails {
        let requestData = Data.GameDetailsRequest(id: id)
        let response = try await networkService.request(
            GameEndpoint.gameDetails(requestData),
            responseType: Data.GameDetails.self
        )
        return GameDetailsMapper.map(from: response)
    }
    
    func getGameScreenshots(id: Int, count: Int) async throws -> [Domain.Screenshot] {
        let requestData = Data.GameScreenshotsRequest(id: id, count: count)
        let response = try await networkService.request(
            GameEndpoint.gameScreenshots(requestData),
            responseType: Data.Screenshots.self
        )
        return ScreenshotMapper.map(from: response)
    }
}
