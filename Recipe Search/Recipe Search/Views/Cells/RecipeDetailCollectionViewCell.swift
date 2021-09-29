//
//  RecipeDetailCollectionViewCell.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/28/21.
//

import UIKit

final class RecipeDetailCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with ingredient: String) {
        titleLabel.text = ingredient
        quantityLabel.text = nil
    }

    func configure(with nutrient: Nutrient) {
        titleLabel.text = nutrient.name
        quantityLabel.text = String(format: "%.1f", nutrient.quantity) + " \(nutrient.unit)"
    }
}
