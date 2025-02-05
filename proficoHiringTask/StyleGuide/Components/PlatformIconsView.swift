//
//  PlatformIconsView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 30. 1. 2025..
//

import UIKit

extension StyleGuide.Components {
    class PlatformIconsView: UIView {
        private enum GamePlatform: Int {
            case pc = 1
            case playstation, xbox, ios, android, mac, linux, nintendo, atari, comodore, sega, threeDo, web
            
            var image: UIImage? {
                let image = UIImage(named: String(describing: self))
                return image?.withTintColor(StyleGuide.Colors.primaryLabel, renderingMode: .alwaysTemplate)
            }
        }
        
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
        
        func setData(platforms: [Int], cutOffAfter: Int? = nil) {
            removeAll()
            let gamePlatforms: [GamePlatform] = platforms.compactMap(GamePlatform.init(rawValue:)).sorted(by: { $0.rawValue < $1.rawValue })
            guard let cutOffAfter else {
                addAllPlatforms(gamePlatforms)
                return
            }
            
            let visiblePlatforms = gamePlatforms.prefix(cutOffAfter)
            let otherPlatformsCount = gamePlatforms.dropFirst(cutOffAfter).count
            visiblePlatforms.forEach { platform in
                addImageView(for: platform)
            }
            addMoreLabel(remainingCount: otherPlatformsCount)
            stackView.addArrangedSubview(.init())
        }
        
        func removeAll() {
            stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        }
    }
}

private extension StyleGuide.Components.PlatformIconsView {
    private func configureSubviews() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addAllPlatforms(_ platforms: [GamePlatform]) {
        platforms.forEach { platform in
            addImageView(for: platform)
        }
        stackView.addArrangedSubview(.init())
    }
    
    private func addImageView(for platform: GamePlatform) {
        let imageView = UIImageView(image: platform.image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = StyleGuide.Colors.primaryLabel
        
        stackView.addArrangedSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0)
        ])
    }
    
    private func addMoreLabel(remainingCount: Int) {
        guard remainingCount > 0 else { return }
        let label = UILabel()
        label.font = StyleGuide.Fonts.bodyBold
        label.textColor = StyleGuide.Colors.primaryLabel
        label.adjustsFontSizeToFitWidth = true
        label.text = "+\(remainingCount)"
        stackView.addArrangedSubview(label)
    }
}
