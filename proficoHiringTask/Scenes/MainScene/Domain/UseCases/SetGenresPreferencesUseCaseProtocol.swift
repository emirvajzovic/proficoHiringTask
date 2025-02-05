//
//  SetGenresPreferencesUseCaseProtocol.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

import Combine

protocol SetGenresPreferencesUseCase {
    func execute(genres: [Int]) throws
}
