//
//  GenreSelectionViewModel.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

import Combine

class GenreSelectionViewModel {
    enum ViewState {
        case idle
        case loading
        case success([Presentation.Genre])
        case failure(Error)
    }
    
    enum ViewEvent {
        case getData(reload: Bool)
        case toggleSelection(_ id: Int)
        case cancel
        case saveSelection
    }
    
    enum ViewResult {
        case finishedSelection
    }
        
    @Injected private var fetchGenresUseCase: FetchGenresUseCase
    @Injected private var setGenresPreferencesUseCase: SetGenresPreferencesUseCase
    @Injected private var fetchGenresPreferencesUseCase: FetchGenresPreferencesUseCase
    
    @Published var state: ViewState = .idle
    
    private var items: [Presentation.Genre] = [] {
        didSet {
            state = .success(items)
            validSelection.send(items.contains(where: \.selected))
        }
    }
    
    private let validSelection: PassthroughSubject<Bool, Never> = .init()
    var onSelectionChanged: AnyPublisher<Bool, Never> {
        validSelection.eraseToAnyPublisher()
    }
    
    private let result: PassthroughSubject<ViewResult, Never> = .init()
    var onResult: AnyPublisher<ViewResult, Never> {
        result.eraseToAnyPublisher()
    }
    
    func trigger(_ event: ViewEvent) {
        switch event {
        case .getData(reload: let reload):
            getData(reload: reload)
        case .toggleSelection(let itemId):
            toggleSelection(for: itemId)
        case .cancel:
            result.send(.finishedSelection)
        case .saveSelection:
            let selectedGenres = items.filter(\.selected).map(\.id)
            setGenresPreferences(selectedGenres)
            result.send(.finishedSelection)
        }
    }
}
private extension GenreSelectionViewModel {
    func toggleSelection(for id: Int) {
        let genres: [Presentation.Genre] = items.map { genre in
            guard genre.id == id else {
                return genre
            }
            return .init(id: genre.id, name: genre.name, backgroundImage: genre.backgroundImage, selected: !genre.selected)
        }
        items = genres
    }
    
    func getData(reload: Bool = false) {
        Task {
            if reload == false { state = .loading }
            do {
                let data = try await fetchGenresUseCase.execute()
                let preferences = fetchGenresPreferences()
                let genres: [Presentation.Genre] = data.map { genre in
                        .init(id: genre.id,
                              name: genre.name,
                              backgroundImage: genre.imageBackground,
                              selected: preferences.contains(genre.id)
                        )
                }
                items = genres
            } catch(let error) {
                state = .failure(error)
#if DEBUG
                print("Error fetching genres:", error)
#endif
            }
        }
    }
    
    func setGenresPreferences(_ genres: [Int]) {
        do {
            try setGenresPreferencesUseCase.execute(genres: genres)
        } catch(let error) {
#if DEBUG
            print("Failed to set genres preferences:", error)
#endif
        }
    }
    
    func fetchGenresPreferences() -> [Int] {
        do {
            return try fetchGenresPreferencesUseCase.execute()
        } catch(let error) {
#if DEBUG
            print("Failed to fetch genres preferences:", error)
#endif
            return []
        }
    }
}
