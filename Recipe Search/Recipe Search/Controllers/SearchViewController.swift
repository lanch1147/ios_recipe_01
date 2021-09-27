//
//  SearchViewController.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/24/21.
//

import UIKit

final class SearchViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let searchBar = PinkSearchBar()
    private var sections = [SearchScreenSection]()
    
    private enum SupplementaryKind: String {
        case header
    }
    
    private enum LayoutOptions {
        static let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(44))
        static let defaultPadding: CGFloat = 8
        static let defaultItemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                                            heightDimension: .absolute(40))
        static let filterGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .absolute(40))
        static let selectedSectionInsets = NSDirectionalEdgeInsets(top: 0,
                                                                   leading: 20,
                                                                   bottom: 16,
                                                                   trailing: 20)
        static let filterSectionInsets = NSDirectionalEdgeInsets(top: 0,
                                                                 leading: 20,
                                                                 bottom: 20,
                                                                 trailing: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBaseSections()
        setupSearchBar()
        setupCollectionView()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    private func setupCollectionView() {
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(ofType: SelectedFilterCollectionViewCell.self)
        collectionView.registerCell(ofType: FilterCollectionViewCell.self)
        collectionView.registerSupplementaryView(ofType: SearchScreenReusableHeader.self,
                                                 forKind: SupplementaryKind.header.rawValue)
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
    }
    
    private func generateSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = LayoutOptions.headerSize
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: SupplementaryKind.header.rawValue,
                                                                 alignment: .top)
        return header
    }
    
    private func generateSelectedSection() -> NSCollectionLayoutSection {
        let itemSize = LayoutOptions.defaultItemSize
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = LayoutOptions.selectedSectionInsets
        section.interGroupSpacing = LayoutOptions.defaultPadding
        return section
    }
    
    private func generateFilterOptionSection() -> NSCollectionLayoutSection {
        let itemSize = LayoutOptions.defaultItemSize
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = LayoutOptions.filterGroupSize
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(LayoutOptions.defaultPadding)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = LayoutOptions.filterSectionInsets
        section.interGroupSpacing = LayoutOptions.defaultPadding
        section.boundarySupplementaryItems = [generateSectionHeader()]
        return section
    }
    
    private func generateLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            return sectionIndex == 0 ? self.generateSelectedSection() : self.generateFilterOptionSection()
        }
        return layout
    }
    
    @IBSegueAction func viewResultScreen(_ coder: NSCoder, sender: Any?) -> ResultViewController? {
        let text = searchBar.text
        let selectedCategories = sections[0].filters
        let request = RecipeRequest(recipeName: text, categories: selectedCategories)
        let tilte = "Results for \"\(text ?? "")\""
        return ResultViewController(coder: coder, initalRequest: request, title: tilte)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    private func createBaseSections() {
        let selectedSection = SearchScreenSection(name: "Selected", filters: [])
        sections.append(selectedSection)
        let mealSection = SearchScreenSection(name: "Meal", filters: Meal.allCases)
        sections.append(mealSection)
        let dishTypeSection = SearchScreenSection(name: "Dish Type", filters: DishType.allCases)
        sections.append(dishTypeSection)
        let cuisineSection = SearchScreenSection(name: "Cuisine", filters: Cuisine.allCases)
        sections.append(cuisineSection)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].filters[indexPath.item]
        if indexPath.section == 0 {
            let cell = collectionView.dequeueCell(ofType: SelectedFilterCollectionViewCell.self, at: indexPath)
            cell.configure(with: item)
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueCell(ofType: FilterCollectionViewCell.self, at: indexPath)
            cell.configure(with: item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueView(ofType: SearchScreenReusableHeader.self,
                                                forKind: SupplementaryKind.header.rawValue,
                                                at: indexPath)
        header.configure(with: sections[indexPath.section].name)
        return header
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = sections[indexPath.section].filters[indexPath.item]
        sections[0].filters.append(selectedItem)
        let indexPath = IndexPath(item: sections[0].filters.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let unselectedItem = sections[indexPath.section].filters[indexPath.item]
        if let removeIndex = sections[0].filters.firstIndex(where: { $0.name() == unselectedItem.name() }) {
            sections[0].filters.remove(at: removeIndex)
            let indexPath = IndexPath(item: removeIndex, section: 0)
            collectionView.deleteItems(at: [indexPath])
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "ShowResultFromSearchSegue", sender: searchBar)
    }
}

extension SearchViewController: SelectedFilterCollectionViewCellDelegate {
    func didSelectRemoveButton(at cell: SelectedFilterCollectionViewCell) {
        guard let removeIndexPath = collectionView.indexPath(for: cell) else { return }
        let removeItem = sections[removeIndexPath.section].filters[removeIndexPath.item]
        sections[removeIndexPath.section].filters.remove(at: removeIndexPath.item)
        collectionView.deleteItems(at: [removeIndexPath])
        collectionView.indexPathsForSelectedItems?.forEach { indexPath in
            let item = sections[indexPath.section].filters[indexPath.item]
            if item.name() == removeItem.name() {
                self.collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }
}
