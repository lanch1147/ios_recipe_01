//
//  IngredientSectionReusableHeader.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/28/21.
//

import UIKit

final class IngredientSectionReusableHeader: UICollectionReusableView, ReusableView {
    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var sourceNameLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var numServingsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 15
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelRemainingLoadingTask()
        imageView.image = nil
    }
    
    func configure(with recipe: Recipe) {
        recipeNameLabel.text = recipe.name
        sourceNameLabel.text = "by \(recipe.sourceName)"
        let text = recipe.defaultNumServings == 1 ? "serving" : "servings"
        numServingsLabel.text = "\(recipe.defaultNumServings) \(text)"
        guard let url = recipe.imageURL else { return }
        imageView.load(with: url)
    }
}
