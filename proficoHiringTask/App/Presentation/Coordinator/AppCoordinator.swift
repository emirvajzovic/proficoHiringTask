//
//  AppCoordinator.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import Combine
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [ChildCoordinator]()
    
    @Injected private var preferencesRepository: PreferencesRepository
    @Injected private var keychainRepository: KeychainRepository
    
    init(on navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let _ = keychainRepository.getApiKey() else {
            presentLoading()
            return
        }
        presentMainFlow()
    }
}

private extension AppCoordinator {
    func presentMainFlow() {
        do {
            _ = try preferencesRepository.getFavoriteGenres()
            presentHomeFlow()
        } catch {
            presentOnboarding()
        }
    }
    
    func presentLoading() {
        let viewModel = SplashScreenViewModel()
        let splashScreenViewController = SplashScreenViewController(viewModel: viewModel)
        splashScreenViewController.modalPresentationStyle = .fullScreen
        
        var cancellable: AnyCancellable?
        cancellable = viewModel.onResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                splashScreenViewController.dismiss(animated: false)
                presentOnboarding()
                cancellable?.cancel()
            }
        
        navigationController.present(splashScreenViewController, animated: false)
    }
    
    func presentOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(from: self)
        onboardingCoordinator.start()
        var cancellable: AnyCancellable?
        cancellable = onboardingCoordinator.onEnded
            .sink { [weak self] in
                guard let self else { return }
                presentHomeFlow()
                removeChild(onboardingCoordinator)
                cancellable?.cancel()
            }
        childCoordinators.append(onboardingCoordinator)
    }
    
    func presentHomeFlow() {
        let homeFlowCoordinator = MainFlowCoordinator(from: self)
        childCoordinators.append(homeFlowCoordinator)
        homeFlowCoordinator.start()
    }
}
