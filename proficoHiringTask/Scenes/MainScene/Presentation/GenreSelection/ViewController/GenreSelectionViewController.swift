//
//  GenreSelectionViewController.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 30. 1. 2025..
//

import Combine
import UIKit

class GenreSelectionViewController: UIViewController {
    enum ViewControllerRole {
        case onboarding, settings
    }
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Presentation.Genre>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Presentation.Genre>
    
    private lazy var leftBarButtonItem = UIBarButtonItem(title: .init(), style: .done, target: self, action: #selector(cancel))
    private lazy var rightBarButtonItem = UIBarButtonItem(title: .init(), style: .done, target: self, action: #selector(saveSelection))
    
    private lazy var titleView: StyleGuide.Components.TitleSubtitleView = {
        let view = StyleGuide.Components.TitleSubtitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separatorView: UIView = {
        return StyleGuide.Components.SeparatorView()
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView(title: Strings.NoDataView.title, subtitle: Strings.NoDataView.message)
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
    
    private lazy var refreshControl: StyleGuide.Components.CustomRefreshControl = {
        let control = StyleGuide.Components.CustomRefreshControl()
        control.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        return control
    }()
    
    private lazy var dataSource = makeCollectionViewDataSource()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .init(
            top: StyleGuide.Layout.Spacing.large,
            left: .zero,
            bottom: StyleGuide.Layout.Spacing.large,
            right: .zero
        )
        collectionView.register(GenreSelectionCollectionViewCell.self, forCellWithReuseIdentifier: GenreSelectionCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    @Injected private var imageLoader: ImageLoadingService
    let viewModel: GenreSelectionViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: GenreSelectionViewModel, role: ViewControllerRole) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configureNavigationBar(for: role)
        setTitle(for: role)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        setCollectionViewDataSource()
        setViewModelListeners()
        viewModel.trigger(.getData(reload: false))
    }
}

private extension GenreSelectionViewController {
    func configureNavigationBar(for role: ViewControllerRole) {
        switch role {
        case .onboarding:
            rightBarButtonItem.title = Strings.GenreSelection.BarButtons.next
        case .settings:
            leftBarButtonItem.title = Strings.GenreSelection.BarButtons.cancel
            rightBarButtonItem.title = Strings.GenreSelection.BarButtons.save
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func setTitle(for role: ViewControllerRole) {
        let title: String
        let subtitle: String
        switch role {
        case .onboarding:
            title = Strings.GenreSelection.titleWelcome
        case .settings:
            title = Strings.GenreSelection.titleSettings
        }
        subtitle = Strings.GenreSelection.subtitle
        titleView.setTitle(title: title, subtitle: subtitle)
    }
    
    func configureSubviews() {
        view.backgroundColor = StyleGuide.Colors.primaryBackground
        view.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: StyleGuide.Layout.Spacing.medium),
            titleView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -StyleGuide.Layout.Spacing.medium),
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: StyleGuide.Layout.Spacing.small),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: StyleGuide.Layout.Spacing.extraSmall),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -StyleGuide.Layout.Spacing.extraSmall),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
            loadingView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: StyleGuide.Layout.Spacing.small + collectionView.contentInset.top),
            loadingView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
        
        view.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setViewModelListeners() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle:
                    applySnapshot([])
                case .loading:
                    setLoading(true)
                    showNoDataView(false)
                case .success(let items):
                    showNoDataView(false)
                    setLoading(false)
                    applySnapshot(items)
                case .failure(_):
                    setLoading(false)
                    showNoDataView(true)
                }
            }.store(in: &cancellables)
        
        viewModel.onSelectionChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] valid in
                guard let self else { return }
                rightBarButtonItem.isEnabled = valid
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
        guard dataSource.snapshot().numberOfItems == 0 else { return }
        noDataView.isHidden = !show
    }
 
    @objc func cancel() {
        viewModel.trigger(.cancel)
    }
    
    @objc func saveSelection() {
        viewModel.trigger(.saveSelection)
    }
    
    @objc func refreshControlAction() {
        refreshControl.beginRefreshing()
        viewModel.trigger(.getData(reload: true))
    }
}

extension GenreSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.trigger(.toggleSelection(item.id))
    }
}

private extension GenreSelectionViewController {
    func setCollectionViewDataSource() {
        collectionView.dataSource = dataSource
    }
    
    func makeCollectionViewDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item -> UICollectionViewCell? in
            guard
                let self,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreSelectionCollectionViewCell.reuseIdentifier, for: indexPath) as? GenreSelectionCollectionViewCell
            else { return nil }
            cell.configure(with: item, imageLoader: imageLoader)
            return cell
        }
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: .zero,
            leading: StyleGuide.Layout.Spacing.extraSmall,
            bottom: StyleGuide.Layout.Spacing.medium,
            trailing: StyleGuide.Layout.Spacing.extraSmall)
    
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func applySnapshot(_ items: [Presentation.Genre], animatingDifferences: Bool = true) {
      var snapshot = Snapshot()
      snapshot.appendSections([.main])
      snapshot.appendItems(items)
      dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

#Preview(traits: .portrait, body: {
    UINavigationController(rootViewController: GenreSelectionViewController(viewModel: .init(), role: .settings))
})
