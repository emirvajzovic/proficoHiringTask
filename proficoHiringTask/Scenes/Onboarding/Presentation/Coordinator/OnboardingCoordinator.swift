//
//  OnboardingCoordinator.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import Combine
import UIKit

final class OnboardingCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [ChildCoordinator] = []
    
    var onEnded: PassthroughSubject<Void, Never> = .init()
    
    init(from parent: Coordinator) {
        self.parentCoordinator = parent
        self.navigationController = .init()
    }
    
    func start() {
        let viewModel = GenreSelectionViewModel()
        var cancellable: AnyCancellable?
        cancellable = viewModel.onResult
            .sink { [weak self] _ in
                guard let self else { return }
                end()
                cancellable?.cancel()
            }
        
        let genreSelectionViewController = GenreSelectionViewController(viewModel: viewModel, role: .onboarding)
        navigationController = UINavigationController(rootViewController: genreSelectionViewController)
        navigationController.modalPresentationStyle = .fullScreen
        parentCoordinator?.navigationController.present(navigationController, animated: true)
    }
    
    func end() {
        navigationController.dismiss(animated: true)
        onEnded.send(())
    }
}
