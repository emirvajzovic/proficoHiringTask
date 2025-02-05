//
//  StandardPreferencesRepository.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

import Combine
import Foundation

final class StandardPreferencesRepository: PreferencesRepository {
    private let defaults: UserDefaults
    let dataPublisher: PassthroughSubject<[Int], Never>
    
    private enum UserDefaultsKeys: String {
        case favoriteGenres = "UserDefaults.FavoriteGenres"
    }
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.dataPublisher = PassthroughSubject<[Int], Never>()
    }
    
    func store(favoriteGenres: [Int]) {
        defaults.set(favoriteGenres, forKey: UserDefaultsKeys.favoriteGenres.rawValue)
        dataPublisher.send(favoriteGenres)
    }
    
    func getFavoriteGenres() throws -> [Int] {
        guard let data = defaults.array(forKey: UserDefaultsKeys.favoriteGenres.rawValue) as? [Int] else {
            throw Domain.PreferenceError.notFound
        }
        
        return data
    }
}
