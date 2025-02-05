//
//  GamesListUseCase.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

import Combine

protocol GamesListUseCase {
    var dataPublisher: AnyPublisher<[Int], Never>? { get }
    func execute(page: Int, pageSize: Int) async throws -> [Domain.Game]
}
