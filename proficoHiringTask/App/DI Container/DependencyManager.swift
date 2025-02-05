//
//  DependencyManager.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//


struct DependencyManager {
    static let container = Container.shared
    
    static func registerDependencies() {
        container.register(StandardFirebaseRepository(), as: FirebaseRepository.self)
        container.register(StandardKeychainRepository(), as: KeychainRepository.self)
        
        container.register(StandardNetworkService(), as:NetworkService.self)
        container.register(StandardImageLoadingService(), as:ImageLoadingService.self)
        
        container.register(StandardGamesRepository(), as:GamesRepository.self)
        container.register(StandardGenresRepository(), as:GenresRepository.self)
        container.register(StandardPreferencesRepository(), as:PreferencesRepository.self)
        
        container.register(StandardFetchApiKeyUseCase(), as:FetchApiKeyUseCase.self)
        container.register(StandardGamesListUseCase(), as:GamesListUseCase.self)
        container.register(StandardGameDetailsUseCase(), as:GameDetailsUseCase.self)
        container.register(StandardFetchGenresUseCase(), as:FetchGenresUseCase.self)
        container.register(StandardFetchGameDetailsUseCase(), as:FetchGameDetailsUseCase.self)
        container.register(StandardSetGenresPreferencesUseCase(), as:SetGenresPreferencesUseCase.self)
        container.register(StandardFetchGenresPreferencesUseCase(), as:FetchGenresPreferencesUseCase.self)
    }
}
