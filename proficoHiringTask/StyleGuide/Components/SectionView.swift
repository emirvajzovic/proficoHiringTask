//
//  SectionView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

import UIKit

extension StyleGuide.Components {
    class SectionView: UIView {
        private lazy var itemsStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = StyleGuide.Layout.Spacing.extraSmall
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        init() {
            super.init(frame: .zero)
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
        
        func setData(title: String?, content: UIView) {
            if let title {
                let titleView = SectionTitleView(title: title)
                itemsStackView.addArrangedSubview(titleView)
            }
            itemsStackView.addArrangedSubview(content)
        }
    }
}
