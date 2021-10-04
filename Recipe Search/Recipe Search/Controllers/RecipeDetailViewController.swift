//
//  RecipeDetailViewController.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/24/21.
//

import UIKit
import SafariServices

final class RecipeDetailViewController: UIViewController {
    @IBOutlet private weak var heartButtonItem: UIBarButtonItem!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var cookButton: UIButton!
    
    private var recipe: Recipe
    private var isLiked = false
    
    private enum SupplementKind: String {
        case ingredientHeader
        case nutrientHeader
    }
    
    private enum LayoutOptions {
        static let largeHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .estimated(600))
        static let standardHeaderFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                     heightDimension: .estimated(30))
        static let cookButtonBottomPadding: CGFloat = 20
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
        setupButtons()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLiked = CoreDataManager.shared.isStored(recipeID: recipe.identifier)
        updateHeartButtonAppearance()
    }
    
    private func setupButtons() {
        cookButton.layer.cornerRadius = cookButton.frame.height / 4
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.registerCell(ofType: RecipeDetailCollectionViewCell.self)
        collectionView.registerSupplementaryView(ofType: IngredientSectionReusableHeader.self,
                                                 forKind: SupplementKind.ingredientHeader.rawValue)
        collectionView.registerSupplementaryView(ofType: NutrientSectionReusableHeader.self,
                                                 forKind: SupplementKind.nutrientHeader.rawValue)
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
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
                let section = self.generateListSection(with: [header])
                let bottomPadding = self.cookButton.frame.height + LayoutOptions.cookButtonBottomPadding * 2
                section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                                leading: 0,
                                                                bottom: bottomPadding,
                                                                trailing: 0)
                return section
            }
        }
        return layout
    }
    
    private func updateHeartButtonAppearance() {
        let symbolName = isLiked ? "heart.fill" : "heart"
        heartButtonItem.image = UIImage(systemName: symbolName)
    }
    
    private func presentRemoveAlert() {
        let alertVC = UIAlertController(title: "Do you want to remove this recipe ?",
                                                message: nil,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { _ in
            CoreDataManager.shared.delete(recipeID: self.recipe.identifier)
            self.presentBasicAlert(withTitle: "Removed Successfully",
                                   message: "\"\(self.recipe.name)\" has been removed")
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(removeAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func presentSaveAlert() {
        do {
            try CoreDataManager.shared.save(recipe: recipe)
            presentBasicAlert(withTitle: "Saved Successfully",
                              message: "\"\(recipe.name)\" has been saved")
        } catch let error as NSError {
            presentBasicAlert(withTitle: "Failed",
                              message: "Cannot save recipe \(recipe.name)")
            print("Saving error: \(error)")
            return
        }
    }
    
    @IBAction func pressedHeartButton(_ sender: UIBarButtonItem) {
        isLiked ? presentRemoveAlert() : presentSaveAlert()
        isLiked = !isLiked
        updateHeartButtonAppearance()
    }
    
    @IBAction func pressedCookButton(_ sender: UIButton) {
        guard let url = recipe.sourceURL else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
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
            ? cell.configure(with: recipe.ingredients[indexPath.item])
            : cell.configure(with: recipe.nutrients[indexPath.item])
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
            header.configure(with: recipe)
            return header
        case SupplementKind.nutrientHeader.rawValue:
            let header = collectionView.dequeueView(ofType: NutrientSectionReusableHeader.self,
                                                    forKind: kind,
                                                    at: indexPath)
            return header
        default:
            fatalError("There is no supplementary view for kind \(kind)")
        }
    }
}
