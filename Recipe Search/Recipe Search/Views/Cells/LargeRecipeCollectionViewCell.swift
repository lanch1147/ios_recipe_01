//
//  LargeRecipeCollectionViewCell.swift
//  Recipe Search (Demo)
//
//  Created by Lan Chu on 9/10/21.
//

import UIKit

final class LargeRecipeCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }
    
    func configure(with recipe: Recipe) {
        imageView.image = nil
        titleLabel.text = recipe.name
        descriptionLabel.text = "by \(recipe.sourceName)"
    }
}
