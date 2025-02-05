//
//  GameDetailsUseCase.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

protocol GameDetailsUseCase {
    func getDetails(gameId: Int) async throws -> Domain.GameDetails
    func getScreenshots(gameId: Int, count: Int) async throws -> [Domain.Screenshot]
}
