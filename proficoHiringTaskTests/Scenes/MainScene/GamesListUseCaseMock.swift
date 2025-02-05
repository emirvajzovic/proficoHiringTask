//
//  GamesListUseCaseMock.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 4. 2. 2025..
//

import Combine
import Foundation
@testable import proficoHiringTask

class GamesListUseCaseMock: GamesListUseCase {
    var dataPublisher: AnyPublisher<[Int], Never>?
    
    func execute(page: Int, pageSize: Int) async throws -> [Domain.Game] {
        executeCallCount += 1
        executeParams.append((page, pageSize))
        guard let executeReturnValues else {
            throw NetworkError.invalidResponse
        }
        return executeReturnValues
    }
    
    var executeCalled: Bool {
        executeCallCount > 0
    }
    var executeCallCount = 0
    var executeParams: [(page: Int, pageSize: Int)] = []
    var executeReturnValues: [Domain.Game]?
}
