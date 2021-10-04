//
//  FavoriteViewController.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/14/21.
//

import UIKit

final class FavoriteViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var recipes = [Recipe]()
    
    private enum LayoutOptions {
        static let defaultPadding: CGFloat = 15
        static let itemHeight: CGFloat = 255
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipes = CoreDataManager.shared.fetchAllRecipes()
        collectionView.reloadData()
    }
    
    private func setupNavigationBarAppearance() {
        title = "Cookbook"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 24, weight: .medium),
                                          .foregroundColor: UIColor.customPinkColor]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let backBarItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        backBarItem.tintColor = .customPinkColor
        navigationItem.backBarButtonItem = backBarItem
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(ofType: RecipeCollectionViewCell.self)
        collectionView.setCollectionViewLayout(generateFlowLayout(), animated: true)
    }
    
    func generateFlowLayout() -> UICollectionViewFlowLayout {
        let padding = LayoutOptions.defaultPadding
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: padding,
                                           left: padding,
                                           bottom: padding,
                                           right: padding)
        let itemWidth = (view.frame.size.width - padding * 3) / 2
        layout.itemSize = CGSize(width: itemWidth, height: LayoutOptions.itemHeight)
        return layout
    }
    
    @IBSegueAction func viewRecipeDetailScreen(_ coder: NSCoder, sender: Any?) -> RecipeDetailViewController? {
        guard let cell = sender as? UICollectionViewCell,
              let indexPath = collectionView.indexPath(for: cell)
        else {
            return nil
        }
        return RecipeDetailViewController(coder: coder, recipe: recipes[indexPath.item])
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: RecipeCollectionViewCell.self, at: indexPath)
        cell.configure(with: recipes[indexPath.item])
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailFromFavoriteSegue",
                     sender: collectionView.cellForItem(at: indexPath))
    }
}
