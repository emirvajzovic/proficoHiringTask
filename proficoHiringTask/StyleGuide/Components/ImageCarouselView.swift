//
//  ImageCarouselView.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

import UIKit

extension StyleGuide.Components {
    class ImageCarouselView: UIView {
        @Injected private var imageLoader: ImageLoadingService
        private let images: [String]
        
        private lazy var collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .clear
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.layer.cornerRadius = StyleGuide.Layout.CornerRadius.medium
            collectionView.register(ImagePreviewCollectionViewCell.self, forCellWithReuseIdentifier: ImagePreviewCollectionViewCell.reuseIdentifier)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        
        private lazy var pageControl: UIPageControl = {
            let pageControl = UIPageControl()
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            return pageControl
        }()
        
        private var timer: Timer?
        private let autoscroll: Bool
        
        init(images: [String], autoscroll: Bool = false) {
            self.images = images
            self.autoscroll = autoscroll
            super.init(frame: .zero)
            pageControl.numberOfPages = images.count
            configureSubviews()
            startTimer()
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureSubviews() {
            addSubview(collectionView)
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: 200)
            ])
            
            addSubview(pageControl)
            NSLayoutConstraint.activate([
                pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
                pageControl.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}

extension StyleGuide.Components.ImageCarouselView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StyleGuide.Components.ImagePreviewCollectionViewCell.reuseIdentifier, for: indexPath) as? StyleGuide.Components.ImagePreviewCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(images[indexPath.row], imageLoader: imageLoader)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension StyleGuide.Components.ImageCarouselView {
    func startTimer() {
        guard autoscroll else { return }
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToNextPage() {
        let nextPage = pageControl.currentPage == images.count - 1 ? 0 : pageControl.currentPage + 1
        collectionView.scrollToItem(at: IndexPath(row: nextPage, section: 0), at: .centeredHorizontally, animated: true)
        startTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / collectionView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        startTimer()
    }
}
