//
//  GameDetailsViewController.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 30. 1. 2025..
//

import Combine
import UIKit

class GameDetailsViewController: UIViewController {
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.7
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var platformsView: StyleGuide.Components.PlatformIconsView = {
        let view = StyleGuide.Components.PlatformIconsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 20)
        ])
        return view
    }()
    
    private lazy var titleView: StyleGuide.Components.TitleSubtitleView = .init()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            platformsView,
            titleView
        ])
        stackView.axis = .vertical
        stackView.spacing = StyleGuide.Layout.Spacing.compact
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loadingView: StyleGuide.Components.LoadingIndicatorView = {
        let view = StyleGuide.Components.LoadingIndicatorView()
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separatorView: UIView = StyleGuide.Components.SeparatorView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = .init(top: StyleGuide.Layout.Spacing.medium,
                                        left: .zero,
                                        bottom: StyleGuide.Layout.Spacing.large * 2,
                                        right: .zero)
        scrollView.backgroundColor = StyleGuide.Colors.primaryBackground.withAlphaComponent(0.3)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = StyleGuide.Layout.Spacing.large
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView(title: Strings.NoDataView.title, subtitle: Strings.NoDataView.message)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @Injected private var imageLoader: ImageLoadingService
    let viewModel: GameDetailsViewModel
    private var imageTask: URLSessionDataTask?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: GameDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = StyleGuide.Colors.primaryBackground
        registerForTraitChanges([UITraitUserInterfaceStyle.self], action: #selector(updateGradient))
        configureView()
        setViewModelListeners()
        getData()
    }
}

private extension GameDetailsViewController {
    func configureView() {
        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
        ])
        
        view.addSubview(titleStackView)
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: StyleGuide.Layout.Spacing.extraSmall),
            titleStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: StyleGuide.Layout.Spacing.medium),
            titleStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -StyleGuide.Layout.Spacing.medium)
        ])
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: StyleGuide.Layout.Spacing.extraSmall),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: safeArea.widthAnchor)
        ])
        
        view.addSubview(noDataView)
        NSLayoutConstraint.activate([
            noDataView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            noDataView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            noDataView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: StyleGuide.Layout.Spacing.large),
            loadingView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        view.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        scrollView.addSubview(detailsStackView)
        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            detailsStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: StyleGuide.Layout.Spacing.medium),
            detailsStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -StyleGuide.Layout.Spacing.medium),
            detailsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func setViewModelListeners() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle(let game):
                    setBasicInfoData(for: game)
                case .loading:
                    showNoDataView(false)
                    loadingView.setLoading(true)
                case .success(let items):
                    loadingView.setLoading(false)
                    addSections(items)
                case .failure(_):
                    loadingView.setLoading(false)
                    showNoDataView(true)
                }
            }.store(in: &cancellables)
    }
    
    func getData() {
        viewModel.trigger(.getData)
    }
    
    func setBasicInfoData(for game: Presentation.Game) {
        titleView.setTitle(title: game.name)
        platformsView.setData(platforms: game.platforms)
        loadImage(urlString: game.backgroundImage)
    }
    
    func addSections(_ sections: [GameDetailsViewModel.ViewSection]) {
        detailsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        sections.forEach { section in
            let sectionView = StyleGuide.Components.SectionView()
            let content: UIView
            switch section {
            case .about(let description):
                content = StyleGuide.Components.DescriptionTextView(description: description)
            case .screenshots(let urls):
                content = StyleGuide.Components.ImageCarouselView(images: urls, autoscroll: true)
            case .systemRequirements(_, let description):
                content = StyleGuide.Components.DescriptionTextView(description: description)
            case .metadata(let metadata):
                content = StyleGuide.Components.MetadataView(metadata: metadata)
            }
            sectionView.setData(title: section.title, content: content)
            detailsStackView.addArrangedSubview(sectionView)
        }
    }
    
    func addGradientToBackgroundImageView() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [StyleGuide.Colors.primaryBackground.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: backgroundImageView.frame.size.width, height: backgroundImageView.frame.size.height)
        backgroundImageView.layer.insertSublayer(gradient, at: 0)
    }
    
    func showNoDataView(_ show: Bool) {
        noDataView.isHidden = !show
    }
    
    func loadImage(urlString: String) {
        Task {
            backgroundImageView.image = try? await imageLoader.loadImage(from: urlString)
            self.addGradientToBackgroundImageView()
        }
    }
    
    @objc func updateGradient() {
        backgroundImageView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        addGradientToBackgroundImageView()
    }
}

#Preview(traits: .portrait, body: {
    let game: Presentation.Game = .init(id: 1, name: "Preview game", backgroundImage: "", platforms: [1,2,3], genres: [])
    
    return GameDetailsViewController(viewModel: .init(game: game))
})
