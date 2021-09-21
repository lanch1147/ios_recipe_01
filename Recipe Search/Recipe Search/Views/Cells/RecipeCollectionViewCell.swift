//
//  RecipeCollectionViewCell.swift
//  Recipe Search (Demo)
//
//  Created by Lan Chu on 9/10/21.
//

import UIKit

final class RecipeCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = UIColor(named: "UnselectedCellColor")
    }
    
    func configure(with recipe: Recipe) {
        imageView.image = nil
        titleLabel.text = recipe.name
    }
}
