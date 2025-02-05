//
//  GamesGridCollectionViewCell.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 29. 1. 2025..
//

import UIKit

class GamesGridCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = .init(describing: GamesGridCollectionViewCell.self)
    
    private var imageLoadTask: URLSessionDataTask?
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = StyleGuide.Colors.secondaryBackgroud
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var itemsStackView: UIStackView = {
        let emptyView = UIView()
        emptyView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        let view = UIStackView(arrangedSubviews: [platformIconsView, titleLabel, emptyView])
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = StyleGuide.Layout.Spacing.minimal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var platformIconsView: StyleGuide.Components.PlatformIconsView = {
        let view = StyleGuide.Components.PlatformIconsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 10)
        ])
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = StyleGuide.Fonts.subtitle
        label.textColor = StyleGuide.Colors.primaryLabel
        label.numberOfLines = .zero
        label.minimumScaleFactor = 0.1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        coverImageView.image = nil
        platformIconsView.removeAll()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ game: Presentation.Game, imageLoader: ImageLoadingService) {
        imageLoadTask?.cancel()
        setCornerRadius()
        titleLabel.text = game.name
        platformIconsView.setData(platforms: game.platforms, cutOffAfter: 3)
        loadImage(game.backgroundImage, imageLoader: imageLoader)
    }
}

private extension GamesGridCollectionViewCell {
    func configureSubviews() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4)
        ])
        
        contentView.addSubview(coverImageView)
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: containerView.topAnchor)
        ])
                
        containerView.addSubview(itemsStackView)
        NSLayoutConstraint.activate([
            itemsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: StyleGuide.Layout.Spacing.extraSmall),
            itemsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -StyleGuide.Layout.Spacing.extraSmall),
            itemsStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: StyleGuide.Layout.Spacing.compact),
            itemsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -StyleGuide.Layout.Spacing.compact)
        ])
    }
    
    func setCornerRadius() {
        contentView.layer.cornerRadius = StyleGuide.Layout.CornerRadius.medium
        contentView.clipsToBounds = true
    }
    
    func loadImage(_ urlString: String, imageLoader: ImageLoadingService) {
        imageLoadTask = try? imageLoader.loadImage(from: urlString) { image in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.coverImageView.image = image
            }
        }
    }
}
