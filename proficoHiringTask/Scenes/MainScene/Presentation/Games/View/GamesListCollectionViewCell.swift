//
//  GamesListCollectionViewCell.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 29. 1. 2025..
//

import Foundation
import UIKit

class GamesListCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = .init(describing: GamesListCollectionViewCell.self)
    
    private var imageLoadTask: URLSessionDataTask?
    
    private lazy var itemsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = StyleGuide.Colors.dimButton
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var infoContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = StyleGuide.Colors.secondaryBackgroud.withAlphaComponent(0.95)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [platformIconsView, titleLabel, genresStackView])
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = StyleGuide.Layout.Spacing.extraSmall
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var platformIconsView: StyleGuide.Components.PlatformIconsView = {
        let view = StyleGuide.Components.PlatformIconsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 16)
        ])
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = StyleGuide.Fonts.subtitle
        label.textColor = StyleGuide.Colors.primaryLabel
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genresStackView: StyleGuide.Components.PillsStackView = {
        let view = StyleGuide.Components.PillsStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func prepareForReuse() {
        imageLoadTask?.cancel()
        coverImageView.image = nil
        platformIconsView.removeAll()
        genresStackView.removeAll()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(_ game: Presentation.Game, imageLoader: ImageLoadingService) {
        imageLoadTask?.cancel()
        setCornerRadius()
        titleLabel.text = game.name
        platformIconsView.setData(platforms: game.platforms, cutOffAfter: 3)
        genresStackView.setData(labels: game.genres)
        loadImage(game.backgroundImage, imageLoader: imageLoader)
    }
}

private extension GamesListCollectionViewCell {
    func configureSubviews() {
        contentView.backgroundColor = StyleGuide.Colors.secondaryBackgroud
        
        contentView.addSubview(coverImageView)
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        contentView.addSubview(infoContainerView)
        NSLayoutConstraint.activate([
            infoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        infoContainerView.addSubview(infoStackView)
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: StyleGuide.Layout.Spacing.extraSmall),
            infoStackView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: StyleGuide.Layout.Spacing.medium),
            infoStackView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -StyleGuide.Layout.Spacing.medium),
            infoStackView.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -StyleGuide.Layout.Spacing.extraSmall)
        ])
    }
    
    func setCornerRadius() {
        contentView.layer.cornerRadius = StyleGuide.Layout.CornerRadius.large
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
