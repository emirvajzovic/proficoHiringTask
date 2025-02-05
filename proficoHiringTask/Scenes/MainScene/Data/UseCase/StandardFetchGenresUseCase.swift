//
//  StandardGenresUseCase.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

final class StandardFetchGenresUseCase: FetchGenresUseCase {
    @Injected private var genresRepository: GenresRepository
    @Injected private var preferencesRepository: PreferencesRepository
    
    func execute() async throws -> [Domain.Genre] {
        let response = try await genresRepository.getGenres()
        let genres = response.genres
        return genres
    }
}
