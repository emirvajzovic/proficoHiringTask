//
//  StandardSetGenresPreferencesUseCase.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

import Combine

final class StandardSetGenresPreferencesUseCase: SetGenresPreferencesUseCase {
    @Injected private var preferencesRepository: PreferencesRepository
    
    func execute(genres: [Int]) throws {
        preferencesRepository.store(favoriteGenres: genres)
    }
}
