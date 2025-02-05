//
//  ImageButton.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 30. 1. 2025..
//

import UIKit

extension StyleGuide.Components {
    class ImageButton: UIButton {
        private var image: UIImage?
        private var imagePadding: CGFloat
        
        private lazy var buttonImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = false
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        init(image: UIImage?, configuration: UIButton.Configuration = .plain(), imagePadding: CGFloat = .zero) {
            self.image = image
            self.imagePadding = imagePadding
            super.init(frame: .zero)
            self.configuration = configuration
            configureSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            buttonImageView.image = image
        }
        
        private func configureSubviews() {
            addSubview(buttonImageView)
            NSLayoutConstraint.activate([
                buttonImageView.topAnchor.constraint(equalTo: topAnchor, constant: imagePadding),
                buttonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: imagePadding),
                buttonImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -imagePadding),
                buttonImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -imagePadding)
            ])
        }
    }
}
