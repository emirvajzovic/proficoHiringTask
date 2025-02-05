//
//  LoadingIndicatorView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

import UIKit

extension StyleGuide.Components {
    class LoadingIndicatorView: UIView {
        private lazy var imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = StyleGuide.Icons.iconController
            imageView.tintColor = StyleGuide.Colors.secondaryLabel
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        var hidesWhenStopped: Bool = false {
            didSet {
                setAlpha()
            }
        }
        private var loading: Bool = false {
            didSet {
                isLoading ? startLoading() : stopLoading()
            }
        }
        var isLoading: Bool {
            loading
        }
        
        init() {
            super.init(frame: .zero)
            subviews.forEach({ $0.removeFromSuperview() })
            configureSubviews()
        }
        
        func setLoading(_ isLoading: Bool) {
            loading = isLoading
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

private extension StyleGuide.Components.LoadingIndicatorView {
    func configureSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func startLoading() {
        alpha = 1.0
        startAnimating()
    }
    
    func startAnimating() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = CGFloat.zero
        rotationAnimation.toValue = CGFloat.pi * 4
        rotationAnimation.duration = 1.5
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .default)
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopLoading() {
        setAlpha()
        stopAnimating()
    }
    
    func stopAnimating() {
        imageView.layer.removeAllAnimations()
    }
    
    func setAlpha() {
        alpha = hidesWhenStopped ? .zero : 1.0
    }
}
