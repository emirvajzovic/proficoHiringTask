//
//  HomeFlowCoordinator.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import Combine
import UIKit

final class MainFlowCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [ChildCoordinator] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    var onEnded: PassthroughSubject<Void, Never> = .init()
    
    init(from parent: Coordinator) {
        self.parentCoordinator = parent
        self.navigationController = .init()
    }
    
    func start() {
        presentGames()
    }
    
    func end() {
        onEnded.send(())
    }
}

private extension MainFlowCoordinator {
    func presentGames() {
        let viewModel = GamesViewModel()
        viewModel.onResult
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .presentGameDetails(let game):
                    presentGameDetails(game)
                case .presentSettings:
                    presentGenreSelection()
                }
            }.store(in: &cancellables)
        
        let gamesViewController = GamesViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: gamesViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.prefersLargeTitles = true
        parentCoordinator?.navigationController.present(navigationController, animated: true)
    }
    
    func presentGameDetails(_ game: Presentation.Game) {
        let viewModel = GameDetailsViewModel(game: game)
        let gameDetailsViewController = GameDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(gameDetailsViewController, animated: true)
    }
    
    func presentGenreSelection() {
        let genreSelectionViewModel = GenreSelectionViewModel()
        let genreSelectionViewController = GenreSelectionViewController(viewModel: genreSelectionViewModel, role: .settings)
        
        let modalNavigationController = UINavigationController(rootViewController: genreSelectionViewController)
        modalNavigationController.isModalInPresentation = true
        
        var cancellable: AnyCancellable?
        cancellable = genreSelectionViewModel.onResult
            .sink { _ in
                modalNavigationController.dismiss(animated: true)
                cancellable?.cancel()
            }
        
        navigationController.present(modalNavigationController, animated: true)
    }
}
