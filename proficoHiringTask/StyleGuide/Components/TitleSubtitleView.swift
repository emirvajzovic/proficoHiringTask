//
//  TitleSubtitleView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 28. 1. 2025..
//

import Combine
import UIKit

extension StyleGuide.Components {
    class TitleSubtitleView: UIView {
        private lazy var labelsStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
            stackView.axis = .vertical
            stackView.spacing = .zero
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = StyleGuide.Fonts.titleLarge
            label.numberOfLines = 2
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        
        private lazy var subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = StyleGuide.Fonts.subtitle
            label.numberOfLines = .zero
            label.isHidden = true
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        
        init() {
            super.init(frame: .zero)
            configureSubviews()
        }
        
        init(title: String, subtitle: String? = nil) {
            super.init(frame: .zero)
            configureSubviews()
            setTitle(title: title, subtitle: subtitle)
        }
        
        func setTitle(title: String, subtitle: String? = nil) {
            titleLabel.text = title
            if let subtitle {
                subtitleLabel.text = subtitle
                subtitleLabel.isHidden = false
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureSubviews() {
            addSubview(labelsStackView)
            NSLayoutConstraint.activate([
                labelsStackView.topAnchor.constraint(equalTo: topAnchor),
                labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
