//
//  FilterCollectionViewCell.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/26/21.
//

import UIKit

final class FilterCollectionViewCell: UICollectionViewCell, ReusableView {    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        let selectedView = UIView(frame: bounds)
        selectedView.backgroundColor = .customPinkColor
        selectedBackgroundView = selectedView
        backgroundColor = .unselectedCellColor
        titleLabel.highlightedTextColor = .white
    }
    
    func configure(with category: Category) {
        titleLabel.text = category.name()
    }
}
