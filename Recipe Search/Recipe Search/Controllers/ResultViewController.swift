//
//  ResultViewController.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/24/21.
//

import UIKit

final class ResultViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var initialRequest: RecipeRequest
    private var recipes = [Recipe]()
    private var nextPageURL: URL?
    private var isFetching = false
    
    init?(coder: NSCoder, initalRequest: RecipeRequest) {
        self.initialRequest = initalRequest
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchNextPage(with: initialRequest)
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(ofType: RecipeCollectionViewCell.self)
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
    }
    
    func generateLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ResultViewController: UICollectionViewDataSource {
    private func fetchNextPage(with request: RecipeRequest) {
        isFetching = true
        APIFetcher.shared.fetchData(with: request) { [weak self] (result) in
            guard let self = self else { return }
            self.isFetching = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.recipes += response.recipes
                    self.nextPageURL = response.nextPageURL
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: RecipeCollectionViewCell.self, at: indexPath)
        cell.configure(with: recipes[indexPath.item])
        return cell
    }
}

extension ResultViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.didScrollTo(offsetFromBottom: 200), !isFetching, let nextPageURL = nextPageURL {
            let nextPageRequest = RecipeRequest(completeURL: nextPageURL)
            fetchNextPage(with: nextPageRequest)
        }
    }
}
