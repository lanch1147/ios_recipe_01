//
//  SelectedFilterCollectionViewCell.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/26/21.
//

import UIKit

final class SelectedFilterCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        backgroundColor = .customPinkColor
    }
    
    func configure(with category: Category) {
        titleLabel.text = category.name()
    }
}
