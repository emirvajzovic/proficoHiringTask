//
//  SectionTitleView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

import UIKit

extension StyleGuide.Components {
    class SectionTitleView: UILabel {
        init(title: String) {
            super.init(frame: .zero)
            text = title
            configureView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureView() {
            font = StyleGuide.Fonts.subtitle
            numberOfLines = 2
            adjustsFontSizeToFitWidth = true
        }
    }
}
