//
//  ImagePreviewCollectionViewCell.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

import UIKit

extension StyleGuide.Components {
    class ImagePreviewCollectionViewCell: UICollectionViewCell {
        static let reuseIdentifier: String = .init(describing: ImagePreviewCollectionViewCell.self)
        
        private lazy var imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = StyleGuide.Layout.CornerRadius.medium
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: .zero)
            configureSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureSubviews() {
            contentView.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
        
        func configure(_ imageUrl: String, imageLoader: ImageLoadingService) {
            Task {
                imageView.image = try? await imageLoader.loadImage(from: imageUrl)
            }
        }
    }
}
