//
//  RecipeCollectionViewCell.swift
//  Recipe Search (Demo)
//
//  Created by Lan Chu on 9/10/21.
//

import UIKit

final class RecipeCollectionViewCell: UICollectionViewCell, ReusableView, RecipeConfigurableCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .unselectedCellColor
    }
    
    func configure(with recipe: Recipe) {
        imageView.image = nil
        titleLabel.text = recipe.name
        
        guard let imageURL = recipe.imageURL else { return }
        imageView.load(with: imageURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelRemainingLoadingTask()
        imageView.image = nil
    }
}
