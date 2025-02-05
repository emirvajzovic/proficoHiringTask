//
//  CustomRefreshControl.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

import UIKit

extension StyleGuide.Components {
    class CustomRefreshControl: UIRefreshControl {
        private let loadingIndicatorView = LoadingIndicatorView()
        
        private var scrollView: UIScrollView? {
            superview as? UIScrollView
        }
        
        override init() {
            super.init()
            configureSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func beginRefreshing() {
            super.beginRefreshing()
            loadingIndicatorView.setLoading(true)
        }
        
        override func endRefreshing() {
            super.endRefreshing()
            loadingIndicatorView.setLoading(false)
        }
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            addObservers()
        }
        
        override func removeFromSuperview() {
            super.removeFromSuperview()
            removeObservers()
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "contentOffset" {
                guard let offset = change?[NSKeyValueChangeKey.newKey] as? CGPoint else { return }
                updateAppearance(for: offset.y)
            }
        }
    }
}

private extension StyleGuide.Components.CustomRefreshControl {
    func configureSubviews() {
        tintColor = .clear
        backgroundColor = .clear
        addSubview(loadingIndicatorView)
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: StyleGuide.Layout.Spacing.compact)
        ])
    }
    
    func addObservers() {
        guard scrollView != nil else { return }
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
    
    func removeObservers() {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    func updateAppearance(for offset: CGFloat) {
        guard isRefreshing == false else { return }
        let offsetY = offset
        let pullDistance = max(0, -offsetY - (scrollView?.contentInset.top ?? .zero))
        let maxPullDistance: CGFloat = 100
        let value = min(1, pullDistance / maxPullDistance)
        let rotationDegree = CGFloat.pi * value * 2
        loadingIndicatorView.transform = CGAffineTransform(rotationAngle: rotationDegree)
        loadingIndicatorView.alpha = value
    }
}
