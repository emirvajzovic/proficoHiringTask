//
//  DescriptionTextView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 30. 1. 2025..
//

import UIKit

extension StyleGuide.Components {
    class DescriptionTextView: UIView {
        private lazy var itemsStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                descriptionLabel,
                buttonContainerView
            ])
            stackView.axis = .vertical
            stackView.spacing = .zero
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        private lazy var descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = StyleGuide.Fonts.body
            label.numberOfLines = 6
            return label
        }()
        
        private lazy var buttonContainerView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                showMoreLessButton,
                .init()
            ])
            stackView.axis = .horizontal
            stackView.distribution = .equalCentering
            return stackView
        }()
        
        private lazy var showMoreLessButton: UIButton = {
            var configuration: UIButton.Configuration = .plain()
            configuration.baseForegroundColor = StyleGuide.Colors.primaryLabel
            configuration.contentInsets = .init(top: StyleGuide.Layout.Spacing.compact,
                                                leading: .zero,
                                                bottom: StyleGuide.Layout.Spacing.compact,
                                                trailing: .zero)
            configuration.attributedTitle = AttributedString("Show more", attributes: buttonTitleAttributes)
            
            let button = UIButton(configuration: configuration)
            button.addTarget(self, action: #selector(showMoreLessButtonAction), for: .touchUpInside)
            return button
        }()
        
        private var buttonTitleAttributes: AttributeContainer {
            let font = StyleGuide.Fonts.caption2
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            return .init(attributes)
        }
        
        private var isTruncated: Bool {
            guard let font = descriptionLabel.font else { return false }
            let lineHeight = font.lineHeight
            let maxTextHeight = lineHeight * CGFloat(descriptionLabel.numberOfLines)
            let actualTextHeight = textHeight
            
            return actualTextHeight > maxTextHeight
        }
        
        private var textHeight: CGFloat {
            guard let text = descriptionLabel.text, let font = descriptionLabel.font else { return .zero }
            let constraintSize = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            
            let boundingBox = text.boundingRect(
                with: constraintSize,
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: attributes,
                context: nil
            )
            
            return boundingBox.height
        }
        
        private var showingMore = false
        
        init(description: String) {
            super.init(frame: .zero)
            descriptionLabel.text = description
            configureSubviews()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            buttonContainerView.isHidden = !isTruncated
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
        
        @objc private func showMoreLessButtonAction() {
            showingMore.toggle()
            showMoreLessButton.configuration?.attributedTitle = AttributedString(showingMore ? "Show less" : "Show more", attributes: buttonTitleAttributes)
            descriptionLabel.numberOfLines = showingMore ? .zero : 6
        }
    }
}
