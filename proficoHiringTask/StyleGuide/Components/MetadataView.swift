//
//  MetadataView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

import UIKit

extension StyleGuide.Components {
    class MetadataView: UIView {
        struct MetadataInfo {
            let title: String
            let description: String
        }
        
        private lazy var mainStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = StyleGuide.Layout.Spacing.medium
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        init(metadata: [MetadataInfo]) {
            super.init(frame: .zero)
            configureSubviews()
            setData(metadata)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

private extension StyleGuide.Components.MetadataView {
    func configureSubviews() {
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setData(_ metadata: [MetadataInfo]) {
        var data = metadata
        while data.count > 1 {
            let firstView = makeBasicInfoView(for: data.removeFirst())
            let secondView = makeBasicInfoView(for: data.removeFirst())
            mainStackView.addArrangedSubview(
                makeHorizontalStackView(with: [firstView, secondView])
            )
        }
        
        if data.count == 1 {
            let view = makeBasicInfoView(for: data.removeFirst())
            mainStackView.addArrangedSubview(
                makeHorizontalStackView(with: [view, .init()])
            )
        }
    }
    
    func makeHorizontalStackView(with views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.spacing = StyleGuide.Layout.Spacing.small
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        return stackView
    }
    
    func makeBasicInfoView(for data: MetadataInfo) -> StyleGuide.Components.BasicInfoView {
        return StyleGuide.Components.BasicInfoView(title: data.title, description: data.description)
    }
}
