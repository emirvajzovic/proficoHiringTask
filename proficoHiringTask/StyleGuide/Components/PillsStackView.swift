//
//  GenresStackView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 31. 1. 2025..
//

import UIKit

extension StyleGuide.Components {
    class PillsStackView: UIView {
        private lazy var stackView: UIStackView = {
            let view = UIStackView()
            view.axis = .horizontal
            view.distribution = .fill
            view.spacing = 5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        init() {
            super.init(frame: .zero)
            configureSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureSubviews() {
            addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        func setData(labels: [String]) {
            let visibleLabels = labels.prefix(3)
            let remainingCount = labels.dropFirst(3).count
            visibleLabels.forEach { genre in
                stackView.addArrangedSubview(PillLabelView(text: genre))
            }
            if remainingCount > 0 {
                stackView.addArrangedSubview(PillLabelView(text: "+\(remainingCount)"))
            }
            stackView.addArrangedSubview(.init())
        }
        
        func removeAll() {
            stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        }
    }
}
