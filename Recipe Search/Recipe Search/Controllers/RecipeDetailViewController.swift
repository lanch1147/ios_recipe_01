//
//  RecipeDetailViewController.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/24/21.
//

import UIKit

final class RecipeDetailViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var recipe: Recipe
    private var numServings = 1
    
    private enum SupplementKind: String {
        case ingredientHeader
        case nutrientHeader
        case nutrientFooter
    }
    
    private enum LayoutOptions {
        static let largeHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .estimated(600))
        static let standardHeaderFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                     heightDimension: .estimated(30))
    }
    
    init?(coder: NSCoder, recipe: Recipe) {
        self.recipe = recipe
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeartButton()
        setupCollectionView()
    }
    
    private func setupHeartButton(isLiked: Bool = false) {
        let config = UIImage.SymbolConfiguration(scale: .large)
        let imageName = isLiked ? "heart.fill" : "heart"
        let heartIcon = UIImage(systemName: imageName, withConfiguration: config)
        let heartButtonItem = UIBarButtonItem(image: heartIcon, style: .plain, target: nil, action: nil)
        heartButtonItem.tintColor = .customPinkColor
        navigationItem.rightBarButtonItem = heartButtonItem
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.registerCell(ofType: RecipeDetailCollectionViewCell.self)
        collectionView.registerSupplementaryView(ofType: IngredientSectionReusableHeader.self,
                                                 forKind: SupplementKind.ingredientHeader.rawValue)
        collectionView.registerSupplementaryView(ofType: NutrientSectionReusableHeader.self,
                                                 forKind: SupplementKind.nutrientHeader.rawValue)
        collectionView.registerSupplementaryView(ofType: NutrientSectionReusableFooter.self,
                                                 forKind: SupplementKind.nutrientFooter.rawValue)
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
    }
    
    private func generateIngredientHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = LayoutOptions.largeHeaderSize
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: SupplementKind.ingredientHeader.rawValue,
                                                                 alignment: .top)
        return header
    }
    
    private func generateNutrientHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = LayoutOptions.standardHeaderFooterSize
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: SupplementKind.nutrientHeader.rawValue,
                                                                 alignment: .top)
        return header
    }
    
    private func generateNutrientFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = LayoutOptions.standardHeaderFooterSize
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                 elementKind: SupplementKind.nutrientFooter.rawValue,
                                                                 alignment: .bottom)
        footer.pinToVisibleBounds = true
        return footer
    }
    
    private func generateListSection(with items: [NSCollectionLayoutBoundarySupplementaryItem]) -> NSCollectionLayoutSection {
        let itemSize = LayoutOptions.standardHeaderFooterSize
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = items
        return section
    }
    
    private func generateLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                let header = self.generateIngredientHeader()
                return self.generateListSection(with: [header])
            } else {
                let header = self.generateNutrientHeader()
                let footer = self.generateNutrientFooter()
                return self.generateListSection(with: [footer, header])
            }
        }
        return layout
    }
}

extension RecipeDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? recipe.ingredients.count : recipe.nutrients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: RecipeDetailCollectionViewCell.self, at: indexPath)
        indexPath.section == 0
            ? cell.configure(with: recipe.ingredients[indexPath.item], numServings: numServings)
            : cell.configure(with: recipe.nutrients[indexPath.item], numServings: numServings)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case SupplementKind.ingredientHeader.rawValue:
            let header = collectionView.dequeueView(ofType: IngredientSectionReusableHeader.self,
                                                    forKind: kind,
                                                    at: indexPath)
            header.configure(with: recipe, numServings: numServings)
            return header
        case SupplementKind.nutrientHeader.rawValue:
            let header = collectionView.dequeueView(ofType: NutrientSectionReusableHeader.self,
                                                    forKind: kind,
                                                    at: indexPath)
            return header
        case SupplementKind.nutrientFooter.rawValue:
            let footer = collectionView.dequeueView(ofType: NutrientSectionReusableFooter.self,
                                                    forKind: kind,
                                                    at: indexPath)
            return footer
        default:
            fatalError("There is no supplementary view for kind \(kind)")
        }
    }
}
