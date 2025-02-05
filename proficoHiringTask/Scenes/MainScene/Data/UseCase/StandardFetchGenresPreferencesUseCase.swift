//
//  StandardGenresPreferencesUseCase.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

final class StandardFetchGenresPreferencesUseCase: FetchGenresPreferencesUseCase {
    @Injected private var repository: PreferencesRepository
    
    func execute() throws -> [Int] {
        try repository.getFavoriteGenres()
    }
}
