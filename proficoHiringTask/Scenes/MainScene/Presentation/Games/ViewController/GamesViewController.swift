//
//  GamesViewController.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 28. 1. 2025..
//

import Combine
import UIKit

class GamesViewController: UIViewController {
    enum Section {
        case main
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Presentation.Game>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Presentation.Game>
    
    private var snapshot = Snapshot()
        
    private lazy var noDataView: NoDataView = {
        let view = NoDataView(title: Strings.NoDataView.title, subtitle: Strings.NoDataView.message, buttonTitle: nil)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loadingView: StyleGuide.Components.LoadingIndicatorView = {
        let view = StyleGuide.Components.LoadingIndicatorView()
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleView: StyleGuide.Components.TitleSubtitleView = {
        let view = StyleGuide.Components.TitleSubtitleView(title: Strings.GamesView.title, subtitle: Strings.GamesView.subtitle)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var settingsButton: StyleGuide.Components.ImageButton = {
        let button = StyleGuide.Components.ImageButton(image: StyleGuide.Icons.settings)
        button.tintColor = StyleGuide.Colors.defaultButton
        button.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalTo: button.widthAnchor)
        ])
        return button
    }()
    
    private var selectedFeedLayout: FeedLayoutSelectorView.FeedLayout = .grid
    private lazy var layoutSelectorView: FeedLayoutSelectorView = {
        let view = FeedLayoutSelectorView(for: selectedFeedLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onSelectionChanged = { [weak self] layout in
            guard let self else { return }
            selectedFeedLayout = layout
            setCollectionViewLayout(for: layout)
            collectionView.reloadData()
        }
        return view
    }()
    
    private lazy var separatorView: UIView = StyleGuide.Components.SeparatorView()
    
    private lazy var refreshControl: StyleGuide.Components.CustomRefreshControl = {
        let control = StyleGuide.Components.CustomRefreshControl()
        control.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        return control
    }()
    
    private lazy var dataSource = makeCollectionViewDataSource()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl
        collectionView.contentInset = .init(
            top: StyleGuide.Layout.Spacing.large,
            left: .zero,
            bottom: StyleGuide.Layout.Spacing.large,
            right: .zero
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GamesGridCollectionViewCell.self, forCellWithReuseIdentifier: GamesGridCollectionViewCell.reuseIdentifier)
        collectionView.register(GamesListCollectionViewCell.self, forCellWithReuseIdentifier: GamesListCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var backToTopButtonContainerView: UIView = {
        let view = UIView()
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backToTopButton: StyleGuide.Components.ImageButton = {
        let button = StyleGuide.Components.ImageButton(image: StyleGuide.Icons.upArrow,
                                                       imagePadding: StyleGuide.Layout.Spacing.extraSmall)
        button.alpha = 0.85
        button.tintColor = StyleGuide.Colors.defaultButton
        button.backgroundColor = StyleGuide.Colors.dimButton
        button.layer.cornerRadius = StyleGuide.Layout.CornerRadius.small
        button.addTarget(self, action: #selector(scrollToTopButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var backToTopButtonBottomAnchor: NSLayoutConstraint = .init()
    private var backToTopButtonHidden: Bool = true {
        didSet {
            backToTopButtonBottomAnchor.constant = backToTopButtonHidden ? 200 : 0
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self else { return }
                backToTopButtonContainerView.alpha = backToTopButtonHidden ? 0 : 0.85
                backToTopButtonContainerView.layoutIfNeeded()
            }
        }
    }
    
    @Injected private var imageLoader: ImageLoadingService
    let viewModel: GamesViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: GamesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        setCollectionViewDataSource()
        setViewModelListeners()
        viewModel.trigger(.getData)
    }
}

private extension GamesViewController {
    func setInitialSnapshot() {
        snapshot.appendSections([.main])
        snapshot.appendItems([])
    }
    
    func setViewModelListeners() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle:
                    setCollectionViewLayout(for: selectedFeedLayout)
                    setInitialSnapshot()
                case .loading:
                    setLoading(true)
                    showNoDataView(false)
                case .success(let items, let reload):
                    setLoading(false)
                    addItems(items, reload)
                    showNoDataView(false)
                case .failure:
                    setLoading(false)
                    showNoDataView(true)
                }
            }.store(in: &cancellables)
    }
    
    func setLoading(_ loading: Bool) {
        guard refreshControl.isRefreshing == false else {
            loading ? nil : refreshControl.endRefreshing()
            return
        }
        collectionView.refreshControl = loading ? nil : refreshControl
        loadingView.setLoading(loading)
    }
    
    func showNoDataView(_ show: Bool) {
        guard show else {
            noDataView.isHidden = true
            return
        }
        noDataView.isHidden = snapshot.numberOfItems > 0
    }
    
    func scrollToTop(animated: Bool = true) {
        let offset = CGPoint(x: .zero,
                             y: -collectionView.contentInset.top)
        collectionView.setContentOffset(offset, animated: animated)
    }
    
    @objc func scrollToTopButtonAction() {
        scrollToTop(animated: true)
    }
    
    @objc func settingsButtonAction() {
        viewModel.trigger(.openSettings)
    }
    
    @objc func refreshControlAction() {
        refreshControl.beginRefreshing()
        viewModel.trigger(.reloadData)
        refreshControl.beginRefreshing()
    }
}

private extension GamesViewController {
    func configureSubviews() {
        view.backgroundColor = StyleGuide.Colors.primaryBackground
        
        let rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: StyleGuide.Layout.Spacing.medium),
            titleView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -StyleGuide.Layout.Spacing.medium)
        ])
        
        view.addSubview(layoutSelectorView)
        NSLayoutConstraint.activate([
            layoutSelectorView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: StyleGuide.Layout.Spacing.extraSmall),
            layoutSelectorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: StyleGuide.Layout.Spacing.medium),
            layoutSelectorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -StyleGuide.Layout.Spacing.medium)
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: layoutSelectorView.bottomAnchor, constant: StyleGuide.Layout.Spacing.small),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: StyleGuide.Layout.Spacing.extraSmall),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -StyleGuide.Layout.Spacing.extraSmall),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(noDataView)
        NSLayoutConstraint.activate([
            noDataView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            noDataView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            noDataView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
        view.sendSubviewToBack(noDataView)
        
        collectionView.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: layoutSelectorView.bottomAnchor, constant: StyleGuide.Layout.Spacing.small + collectionView.contentInset.top),
            loadingView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
        
        view.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(backToTopButtonContainerView)
        NSLayoutConstraint.activate([
            backToTopButtonContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -StyleGuide.Layout.Spacing.medium),
            backToTopButtonContainerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -StyleGuide.Layout.Spacing.medium),
            backToTopButtonContainerView.heightAnchor.constraint(equalToConstant: 40),
            backToTopButtonContainerView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        backToTopButtonBottomAnchor = backToTopButton.bottomAnchor.constraint(equalTo: backToTopButtonContainerView.bottomAnchor)
        backToTopButtonContainerView.addSubview(backToTopButton)
        NSLayoutConstraint.activate([
            backToTopButtonBottomAnchor,
            backToTopButton.trailingAnchor.constraint(equalTo: backToTopButtonContainerView.trailingAnchor),
            backToTopButton.heightAnchor.constraint(equalTo: backToTopButtonContainerView.heightAnchor),
            backToTopButton.widthAnchor.constraint(equalTo: backToTopButtonContainerView.widthAnchor)
        ])
    }
}

extension GamesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let game = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.trigger(.openGameDetails(game))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        showHideScrollToTopButton(for: scrollView.contentOffset.y)
        loadMoreDataIfNeeded(for: scrollView.contentOffset.y)
    }
}

private extension GamesViewController {
    func setCollectionViewLayout(for type: FeedLayoutSelectorView.FeedLayout) {
        let layout = type == .grid ? createGridLayout() : createListLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        scrollToTop(animated: false)
    }
    
    func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: .zero,
            leading: StyleGuide.Layout.Spacing.extraSmall,
            bottom: StyleGuide.Layout.Spacing.medium,
            trailing: StyleGuide.Layout.Spacing.extraSmall)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: .zero,
            leading: StyleGuide.Layout.Spacing.extraSmall,
            bottom: StyleGuide.Layout.Spacing.large,
            trailing: StyleGuide.Layout.Spacing.extraSmall
        )
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.55))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func setCollectionViewDataSource() {
        collectionView.dataSource = dataSource
    }
    
    func makeCollectionViewDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item -> UICollectionViewCell? in
            guard let self else { return nil }
            switch selectedFeedLayout {
            case .grid:
                return buildGridItemCell(for: item, collectionView, at: indexPath)
            case .list:
                return buildListItemCell(for: item, collectionView, at: indexPath)
            }
        }
    }
    
    func buildGridItemCell(for item: Presentation.Game, _ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GamesGridCollectionViewCell.reuseIdentifier, for: indexPath) as? GamesGridCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(item, imageLoader: imageLoader)
        return cell
    }
    
    func buildListItemCell(for item: Presentation.Game, _ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GamesListCollectionViewCell.reuseIdentifier, for: indexPath) as? GamesListCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(item, imageLoader: imageLoader)
        return cell
    }
    
    func addItems(_ items: [Presentation.Game], _ forceReload: Bool, animatingDifferences: Bool = true) {
        if forceReload {
            refreshControl.endRefreshing()
            snapshot = Snapshot()
            setInitialSnapshot()
        }
        applySnapshot(items, forceReload)
    }
    
    func applySnapshot(_ items: [Presentation.Game], _ forceReload: Bool, animatingDifferences: Bool = true) {
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        forceReload ? scrollToTop() : nil
    }
    
    func showHideScrollToTopButton(for scrollOffset: CGFloat) {
        guard scrollOffset > 300 else {
            setScrollToTopButtonHidden(true, scrollOffset: scrollOffset)
            return
        }
        setScrollToTopButtonHidden(false, scrollOffset: scrollOffset)
    }
    
    func setScrollToTopButtonHidden(_ hidden: Bool, scrollOffset: CGFloat) {
        guard backToTopButtonHidden != hidden else { return }
        backToTopButtonHidden = hidden
    }
    
    func loadMoreDataIfNeeded(for scrollOffset: CGFloat) {
        guard
            scrollOffset > 0,
            scrollOffset > collectionView.contentSize.height - collectionView.frame.size.height
        else { return }
        viewModel.trigger(.getNextPageData)
    }
}

#Preview(traits: .portrait, body: {
    let viewController = GamesViewController(viewModel: .init())
    return viewController
})
