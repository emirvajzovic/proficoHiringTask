//
//  StandardGenresRepository.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

final class StandardGenresRepository: GenresRepository {
    @Injected private var networkService: NetworkService
    
    func getGenres() async throws -> Domain.PaginatedGenres {
        let response = try await networkService.request(GenreEndpoint.genres, responseType: Data.GenresResponseData.self)
        let pagination = Domain.Pagination(count: response.count, next: response.next, previous: response.previous)
        let genres = response.results.map { GenresMapper.map(from: $0) }
        
        return .init(pagination: pagination,
                     genres: genres)
    }
}
