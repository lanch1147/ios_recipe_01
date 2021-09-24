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
    private var sections = [HomeScreenSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
        setupCollectionView()
        fetchSectionData()
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
        collectionView.delegate = self
        collectionView.dataSource = self
        registerNibs()
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
    }
    
    // MARK: - Navigation Bar
    
    private func setupSearchBar() {
        searchBar.delegate = self
        let attPlaceholder = NSAttributedString(string: "Search for recipes",
                                                attributes: [.foregroundColor: UIColor.white])
        searchBar.searchTextField.attributedPlaceholder = attPlaceholder
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
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
                                                           heightDimension: .absolute(61.5))
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
    
    // MARK: - Segue Actions
    
    @IBSegueAction func viewDetailScreen(_ coder: NSCoder, sender: Any?) -> RecipeDetailViewController? {
        guard let cell = sender as? UICollectionViewCell,
              let indexPath = collectionView.indexPath(for: cell),
              let recipe = sections[indexPath.section].response?.recipes[indexPath.item]
        else {
            return nil
        }
        return RecipeDetailViewController(coder: coder, recipe: recipe)
    }
    
    @IBSegueAction func viewResultScreen(_ coder: NSCoder, sender: Any?) -> ResultViewController? {
        guard let header = sender as? HomeScreenReusableHeader,
              let indexPath = header.indexPath,
              let response = sections[indexPath.section].response
        else {
            return nil
        }
        return ResultViewController(coder: coder, recipeResponse: response)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    private func createBaseSectionArray() -> [HomeScreenSection] {
        var baseSections = [HomeScreenSection]()
        
        let popularRequest = RecipeRequest(recipeName: "popular")
        let popularSection = HomeScreenSection(name: "Popular", request: popularRequest, response: nil)
        baseSections.append(popularSection)
        let categories: [Category] = [Cuisine.american, Cuisine.japanese, Meal.breakfast, DishType.desserts]
        baseSections += categories.map {
            let request = RecipeRequest(categories: [$0])
            let standardSection = HomeScreenSection(name: $0.name(), request: request, response: nil)
            return standardSection
        }
        
        return baseSections
    }
    
    private func fetchSectionData() {
        sections = createBaseSectionArray()
        let dispatchGroup = DispatchGroup()
        for section in 0..<sections.count {
            dispatchGroup.enter()
            APIFetcher.shared.fetchData(with: sections[section].request) { [weak self] (result) in
                switch result {
                case .success(let recipeResponse):
                    self?.sections[section].response = recipeResponse
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let response = sections[section].response
        return response?.recipes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RecipeConfigurableCell
        switch indexPath.section {
        case 0:
            cell = collectionView.dequeueCell(ofType: LargeRecipeCollectionViewCell.self, at: indexPath)
        default:
            cell = collectionView.dequeueCell(ofType: RecipeCollectionViewCell.self, at: indexPath)
        }
        
        let response = sections[indexPath.section].response
        guard let recipe = response?.recipes[indexPath.item] else { return cell }
        cell.configure(with: recipe)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let kind = SupplementaryViewKind.header.rawValue
        let header = collectionView.dequeueView(ofType: HomeScreenReusableHeader.self, forKind: kind, at: indexPath)
        header.delegate = self
        header.configure(with: sections[indexPath.section].name, at: indexPath)
        return header
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailFromHomeSegue", sender: collectionView.cellForItem(at: indexPath))
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        performSegue(withIdentifier: "ShowSearchScreenSegue", sender: nil)
        return false
    }
}

extension HomeViewController: HomeScreenReusableHeaderDelegate {
    func didPressViewAllButton(sender: HomeScreenReusableHeader, at indexPath: IndexPath) {
        guard sections[indexPath.row].response != nil else { return }
        performSegue(withIdentifier: "ShowResultScreenFromHomeSegue", sender: sender)
    }
}
