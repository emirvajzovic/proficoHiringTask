//
//  GamesHeaderView 2.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 31. 1. 2025..
//

import UIKit

class FeedLayoutSelectorView: UIView {
    enum FeedLayout {
        case grid
        case list
    }
    private var layout: FeedLayout {
        didSet {
            onSelectionChanged?(layout)
        }
    }
    var onSelectionChanged: ((FeedLayout) -> Void)?
    
    private lazy var itemsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [.init(), gridViewButton, listViewButton])
        view.axis = .horizontal
        view.spacing = StyleGuide.Layout.Spacing.medium
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var gridViewButton: UIButton = {
        let button = StyleGuide.Components.ImageButton(image: StyleGuide.Icons.iconGrid)
        button.addTarget(self, action: #selector(gridViewButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var listViewButton: StyleGuide.Components.ImageButton = {
        let button = StyleGuide.Components.ImageButton(image: StyleGuide.Icons.iconList)
        button.addTarget(self, action: #selector(listViewButtonAction), for: .touchUpInside)
        return button
    }()
    
    init(for layout: FeedLayout) {
        self.layout = layout
        super.init(frame: .zero)
        configureSubviews()
        layout == .grid ? setGridViewButtonSelected() : setListViewButtonSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FeedLayoutSelectorView {
    func configureSubviews() {
        addSubview(itemsStackView)
        NSLayoutConstraint.activate([
            itemsStackView.topAnchor.constraint(equalTo: topAnchor),
            itemsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc func gridViewButtonAction() {
        setGridViewButtonSelected()
    }
    
    @objc func listViewButtonAction() {
        setListViewButtonSelected()
    }
    
    func setGridViewButtonSelected() {
        layout = .grid
        gridViewButton.tintColor = StyleGuide.Colors.defaultButton
        listViewButton.tintColor = StyleGuide.Colors.dimButton
    }
    
    func setListViewButtonSelected() {
        layout = .list
        gridViewButton.tintColor = StyleGuide.Colors.dimButton
        listViewButton.tintColor = StyleGuide.Colors.defaultButton
    }
}
