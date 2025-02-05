//
//  NoDataView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

import Combine
import UIKit

class NoDataView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = StyleGuide.Icons.iconNoResults
        imageView.tintColor = StyleGuide.Colors.primaryLabel
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var itemsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, buttonStackView, .init()])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = StyleGuide.Layout.Spacing.small
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = StyleGuide.Fonts.title
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = StyleGuide.Fonts.button
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [.init(), button, .init()])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let buttonAction: PassthroughSubject<Void, Never> = .init()
    var onButtonAction: AnyPublisher<Void, Never> {
        buttonAction.eraseToAnyPublisher()
    }
    
    init(title: String, subtitle: String, buttonTitle: String? = nil) {
        super.init(frame: .zero)
        configureSubviews()
        titleLabel.text = title
        subtitleLabel.text = subtitle
        configureButtonIfNeeded(with: buttonTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NoDataView {
    func configureSubviews() {
        addSubview(itemsStackView)
        NSLayoutConstraint.activate([
            itemsStackView.topAnchor.constraint(equalTo: centerYAnchor, constant: -StyleGuide.Layout.Spacing.large),
            itemsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: StyleGuide.Layout.Spacing.extraLarge),
            itemsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -StyleGuide.Layout.Spacing.extraLarge),
            itemsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: itemsStackView.topAnchor, constant: -StyleGuide.Layout.Spacing.medium),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.25)
        ])
    }
    
    func configureButtonIfNeeded(with title: String?) {
        guard let title else {
            buttonStackView.isHidden = true
            return
        }
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = StyleGuide.Colors.tertiaryBackground
        
        let font = StyleGuide.Fonts.body
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: StyleGuide.Colors.defaultButton
        ]
        let attributeContainer = AttributeContainer(attributes)
        configuration.attributedTitle = AttributedString(title, attributes: attributeContainer)
        
        button.configuration = configuration
        button.addTarget(self, action: #selector(viewButtonAction), for: .touchUpInside)
    }
    
    @objc func viewButtonAction() {
        buttonAction.send(())
    }
}
