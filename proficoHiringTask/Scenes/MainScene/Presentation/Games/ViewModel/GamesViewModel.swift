//
//  GamesViewModel.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 30. 1. 2025..
//

import Combine

class GamesViewModel {
    enum ViewState {
        case idle
        case loading
        case success([Presentation.Game], forceReload: Bool)
        case failure(Error?)
    }
    
    enum ViewEvent {
        case getData
        case getNextPageData
        case reloadData
        case openGameDetails(_ game: Presentation.Game)
        case openSettings
    }
    
    enum ViewResult {
        case presentGameDetails(_ game: Presentation.Game)
        case presentSettings
    }
    @Injected private var useCase: GamesListUseCase
    
    @Published var state: ViewState = .idle
    
    private var currentPage = 1
    private let pageSize = 18
    
    private let result: PassthroughSubject<ViewResult, Never> = .init()
    var onResult: AnyPublisher<ViewResult, Never> {
        result.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        useCase.dataPublisher?
            .sink { [weak self] favoriteGenres in
                guard let self else { return }
                reloadData()
            }.store(in: &cancellables)
    }
    
    func trigger(_ event: ViewEvent) {
        switch event {
        case .getData:
            getData()
        case .getNextPageData:
            getMoreData()
        case .reloadData:
            reloadData()
        case .openGameDetails(let game):
            result.send(.presentGameDetails(game))
        case .openSettings:
            result.send(.presentSettings)
        }
    }
}

private extension GamesViewModel {
    func getData() {
        Task {
            state = .loading
            guard let games = await fetchItems() else {
                return
            }
            state = .init(games)
        }
    }
    
    func getMoreData() {
        if case .loading = state { return }
        Task {
            guard await ConnectionService.isConnected() else { return }
            state = .loading
            guard let games = await fetchItems(loadingMore: true) else {
                return
            }
            state = .init(games)
        }
    }
    
    func reloadData() {
        Task {
            currentPage = 1
            guard let games = await fetchItems(reload: true) else {
                return
            }
            state = .init(games, forceReload: true)
        }
    }
    
    func fetchItems(loadingMore: Bool = false, reload: Bool = false) async -> [Domain.Game]? {
        do {
            let games = try await useCase.execute(page: loadingMore ? currentPage + 1 : currentPage, pageSize: pageSize)
            currentPage += loadingMore ? 1 : 0
            return games
        } catch {
            state = .failure(reload ? error : nil)
#if DEBUG
            print("Error failed to fetch games:", error)
#endif
            return nil
        }
    }
}

private extension GamesViewModel.ViewState {
    init(_ items: [Domain.Game], forceReload: Bool = false) {
        let games: [Presentation.Game] = items.map { game in
                .init(id: game.id,
                      name: game.name,
                      backgroundImage: game.backgroundImage,
                      platforms: game.parentPlatforms.map(\.platform.id),
                      genres: game.genres.map(\.name))
        }
        self = .success(games, forceReload: forceReload)
    }
}
