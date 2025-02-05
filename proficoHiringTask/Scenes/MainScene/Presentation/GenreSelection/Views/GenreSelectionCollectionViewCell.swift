//
//  GenreSelectionCollectionViewCell.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

import Combine
import UIKit

class GenreSelectionCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = .init(describing: GenreSelectionCollectionViewCell.self)
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = StyleGuide.Colors.primaryBackground.withAlphaComponent(0.75)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = StyleGuide.Fonts.title
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        setCornerRadius()
        configureAppearance()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.layer.borderWidth = .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: Presentation.Genre, imageLoader: ImageLoadingService) {
        titleLabel.text = item.name
        updateAppearance(selected: item.selected)
        loadBackgroundImage(item.backgroundImage, imageLoader)
    }
}

private extension GenreSelectionCollectionViewCell {
    func configureAppearance() {
        setCornerRadius()
        setBorder()
    }
    
    func configureSubviews() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: StyleGuide.Layout.Spacing.extraSmall),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: StyleGuide.Layout.Spacing.medium),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -StyleGuide.Layout.Spacing.medium),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -StyleGuide.Layout.Spacing.extraSmall),
        ])
    }
    
    func updateAppearance(selected: Bool) {
        contentView.layer.borderWidth = selected ? 2 : .zero
    }
    
    func loadBackgroundImage(_ urlString: String?, _ imageLoader: ImageLoadingService) {
        guard let urlString else { return }
        Task {
            imageView.image = try? await imageLoader.loadImage(from: urlString)
        }
    }
    
    func setCornerRadius() {
        contentView.layer.cornerRadius = StyleGuide.Layout.CornerRadius.medium
        contentView.clipsToBounds = true
    }
    
    func setBorder() {
        contentView.layer.borderColor = StyleGuide.Colors.secondaryLabel.cgColor
    }
}
