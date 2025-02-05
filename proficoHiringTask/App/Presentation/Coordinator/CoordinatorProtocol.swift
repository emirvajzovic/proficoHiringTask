//
//  Coordinator.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 28. 1. 2025..
//

import Combine
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [ChildCoordinator] { get set }
    
    func start()
}

extension Coordinator {
    func removeChild(_ coordinator: ChildCoordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator })
    }
}
