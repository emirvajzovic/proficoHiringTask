//
//  SplashScreenViewController.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import Combine
import UIKit


class SplashScreenViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: StyleGuide.Icons.iconController)
        imageView.tintColor = StyleGuide.Colors.primaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView(title: Strings.NoDataView.title, subtitle: Strings.NoDataView.message, buttonTitle: Strings.SplashScreen.buttonTitle)
        view.isHidden = true
        view.backgroundColor = StyleGuide.Colors.primaryBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.trigger(.getData)
            }.store(in: &cancellables)
        return view
    }()
    
    private let viewModel: SplashScreenViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SplashScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureSubviews()
        setViewModelListeners()
        viewModel.trigger(.getData)
    }
}

private extension SplashScreenViewController {
    func setViewModelListeners() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle:
                    break
                case .loading:
                    showNoDataView(false)
                    startAnimating()
                case .success:
                    showNoDataView(false)
                    stopAnimating()
                case .failure:
                    showNoDataView(true)
                    stopAnimating()
                }
            }.store(in: &cancellables)
    }
    
    func configureSubviews() {
        view.backgroundColor = StyleGuide.Colors.primaryBackground
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.25)
        ])
        
        view.addSubview(noDataView)
        NSLayoutConstraint.activate([
            noDataView.topAnchor.constraint(equalTo: view.topAnchor),
            noDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showNoDataView(_ show: Bool) {
        noDataView.isHidden = !show
    }
    
    func startAnimating() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = CGFloat.zero
        rotationAnimation.toValue = CGFloat.pi * 4
        rotationAnimation.duration = 1.5
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .default)
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopAnimating() {
        imageView.layer.removeAllAnimations()
    }
}
