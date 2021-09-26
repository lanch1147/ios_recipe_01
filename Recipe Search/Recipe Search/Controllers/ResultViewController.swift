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
    
    init?(coder: NSCoder, initalRequest: RecipeRequest, title: String?) {
        self.initialRequest = initalRequest
        super.init(coder: coder)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchNextPage(with: initialRequest)
    }
    
    private enum LayoutOptions {
        static let defaultPadding: CGFloat = 15
        static let itemHeight: CGFloat = 255
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(ofType: RecipeCollectionViewCell.self)
        collectionView.registerSupplementaryView(ofType: LoadingReusableFooter.self,
                                                 forKind: UICollectionView.elementKindSectionFooter)
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
}

extension ResultViewController: UICollectionViewDataSource {
    private func fetchNextPage(with request: RecipeRequest) {
        self.isFetching = true
        self.collectionView.reloadData()
        APIFetcher.shared.fetchData(with: request) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.recipes += response.recipes
                self.nextPageURL = response.nextPageURL
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            self.isFetching = false
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
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueView(ofType: LoadingReusableFooter.self,
                                                forKind: UICollectionView.elementKindSectionFooter,
                                                at: indexPath)
        footer.startAnimating()
        return footer
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

extension ResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return isFetching ? CGSize(width: view.frame.width, height: 100) : .zero
    }
}
