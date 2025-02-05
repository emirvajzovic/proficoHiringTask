//
//  PreferencesRepositoryProtocol.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

import Combine

protocol PreferencesRepository {
    func store(favoriteGenres: [Int])
    func getFavoriteGenres() throws -> [Int]
    var dataPublisher: PassthroughSubject<[Int], Never> { get }
}
