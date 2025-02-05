//
//  ChildCoordinator.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import Combine

protocol ChildCoordinator: Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var onEnded: PassthroughSubject<Void, Never> { get }
    func end()
}
