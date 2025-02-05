//
//  SplashScreenViewModel.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 4. 2. 2025..
//

import Combine
import Foundation

class SplashScreenViewModel {
    enum ViewState {
        case idle
        case loading
        case success
        case failure
    }
    
    enum ViewEvent {
        case getData
    }
    
    @Injected private var useCase: FetchApiKeyUseCase
    @Published var state: ViewState = .idle
    
    private let result: PassthroughSubject<Void, Never> = .init()
    var onResult: AnyPublisher<Void, Never> {
        result.eraseToAnyPublisher()
    }
    
    func trigger(_ event: ViewEvent) {
        switch event {
        case .getData:
            fetchAndStoreApiKey()
        }
    }
    
    private func fetchAndStoreApiKey() {
        Task {
            do {
                state = .loading
                try await useCase.execute()
                state = .success
                result.send(())
            } catch {
                state = .failure
            }
        }
    }
}
