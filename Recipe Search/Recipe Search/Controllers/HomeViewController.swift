//
//  ViewController.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/13/21.
//

import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    private let searchBar = PinkSearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.centerPlaceholder()
    }
    
    // MARK: - Setup Collection View
    
    private func registerNibs() {
        collectionView.registerSupplementaryView(ofType: HomeScreenReusableHeader.self,
                                                 forKind: SupplementaryViewKind.header.rawValue)
        collectionView.registerCell(ofType: LargeRecipeCollectionViewCell.self)
        collectionView.registerCell(ofType: RecipeCollectionViewCell.self)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        registerNibs()
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
    }
    
    // MARK: - Navigation Bar
    
    private func setupSearchBar() {
        let attPlaceholder = NSAttributedString(string: "Search for recipes",
                                                attributes: [.foregroundColor: UIColor.white])
        searchBar.searchTextField.attributedPlaceholder = attPlaceholder
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        
        setupSearchBar()
        navigationItem.titleView = searchBar
    }
    
    // MARK: - Compositional Layout
    enum SupplementaryViewKind: String {
        case header
    }
    
    private enum LayoutOptions {
        static let defaultPadding: CGFloat = 15
        static let fullFilledItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1))
        static let squareItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalWidth(1))
        static let standardGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35),
                                                             heightDimension: .absolute(214))
        static let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .estimated(44))
    }
    
    func generateFullWidthItemSection() -> NSCollectionLayoutSection {
        let padding = LayoutOptions.defaultPadding
        
        let item = NSCollectionLayoutItem(layoutSize: LayoutOptions.fullFilledItemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: LayoutOptions.squareItemSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0,
                                                     bottom: 0, trailing: padding * 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding,
                                                        bottom: 0, trailing: padding)
        section.boundarySupplementaryItems = [generateHeaderItem()]
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    func generateStandardItemSection() -> NSCollectionLayoutSection {
        let padding = LayoutOptions.defaultPadding
        
        let item = NSCollectionLayoutItem(layoutSize: LayoutOptions.fullFilledItemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: LayoutOptions.standardGroupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = padding * 2 / 3
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding,
                                                        bottom: 0, trailing: padding)
        section.boundarySupplementaryItems = [generateHeaderItem()]
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func generateHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let kind = SupplementaryViewKind.header.rawValue
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: LayoutOptions.headerItemSize,
                                                                 elementKind: kind, alignment: .top)
        return header
    }

    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let section = sectionIndex == 0 ? self.generateFullWidthItemSection() : self.generateStandardItemSection()
            return section
        }
        return layout
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return collectionView.dequeueCell(ofType: LargeRecipeCollectionViewCell.self, at: indexPath)
        default:
            return collectionView.dequeueCell(ofType: RecipeCollectionViewCell.self, at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let kind = SupplementaryViewKind.header.rawValue
        let header = collectionView.dequeueView(ofType: HomeScreenReusableHeader.self, forKind: kind, at: indexPath)
        return header
    }
}
