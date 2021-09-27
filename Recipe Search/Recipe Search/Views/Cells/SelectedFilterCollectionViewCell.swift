//
//  SelectedFilterCollectionViewCell.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/26/21.
//

import UIKit

final class SelectedFilterCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    weak var delegate: SelectedFilterCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        backgroundColor = .customPinkColor
    }
    
    func configure(with category: Category) {
        titleLabel.text = category.name()
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        delegate?.didSelectRemoveButton(at: self)
    }
}
