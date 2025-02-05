//
//  StandardFetchApiKeyUseCase.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 4. 2. 2025..
//

final class StandardFetchApiKeyUseCase: FetchApiKeyUseCase {
    @Injected private var keychainRepository: KeychainRepository
    @Injected private var firebaseRepository: FirebaseRepository
    
    func execute() async throws {
        let fetchedKey = try await firebaseRepository.getApiKey()
        keychainRepository.store(apiKey: fetchedKey)
    }
}
