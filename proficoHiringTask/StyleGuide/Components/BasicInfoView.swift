//
//  BasicInfoView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

import UIKit

extension StyleGuide.Components {
    class BasicInfoView: UIView {
        private lazy var itemsStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
            stackView.axis = .vertical
            stackView.spacing = StyleGuide.Layout.Spacing.compact
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = StyleGuide.Fonts.caption
            label.textColor = StyleGuide.Colors.secondaryLabel
            return label
        }()
        
        private lazy var descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = StyleGuide.Fonts.body
            label.textColor = StyleGuide.Colors.primaryLabel
            label.numberOfLines = .zero
            return label
        }()
        
        init(title: String, description: String) {
            super.init(frame: .zero)
            titleLabel.text = title
            descriptionLabel.text = description
            configureSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureSubviews() {
            addSubview(itemsStackView)
            NSLayoutConstraint.activate([
                itemsStackView.topAnchor.constraint(equalTo: topAnchor),
                itemsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                itemsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                itemsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
