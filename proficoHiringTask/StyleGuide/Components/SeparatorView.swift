//
//  SeparatorView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

import UIKit

extension StyleGuide.Components {
    class SeparatorView: UIView {
        private lazy var separator: UIView = {
            let view = UIView()
            view.backgroundColor = StyleGuide.Colors.separator
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            configureSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureSubviews() {
            addSubview(separator)
            NSLayoutConstraint.activate([
                separator.topAnchor.constraint(equalTo: topAnchor),
                separator.leadingAnchor.constraint(equalTo: leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: 1.0)
            ])
        }
    }
}
