//
//  PillLabelView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 31. 1. 2025..
//

import UIKit

extension StyleGuide.Components {
    class PillLabelView: UIView {
        private lazy var pillLabel: UILabel = {
            let label = UILabel()
            label.font = StyleGuide.Fonts.caption
            label.textColor = StyleGuide.Colors.primaryLabel
            label.numberOfLines = 1
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        init(text: String) {
            super.init(frame: .zero)
            pillLabel.text = text
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = bounds.height / 2
        }
        
        private func commonInit() {
            backgroundColor = StyleGuide.Colors.tertiaryBackground
            configureSubviews()
        }
        
        private func configureSubviews() {
            addSubview(pillLabel)
            NSLayoutConstraint.activate([
                pillLabel.topAnchor.constraint(equalTo: topAnchor, constant: StyleGuide.Layout.Spacing.minimal),
                pillLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -StyleGuide.Layout.Spacing.minimal),
                pillLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: StyleGuide.Layout.Spacing.extraSmall),
                pillLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -StyleGuide.Layout.Spacing.extraSmall)
            ])
        }
    }
}
