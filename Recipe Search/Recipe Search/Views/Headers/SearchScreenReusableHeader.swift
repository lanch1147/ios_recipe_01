//
//  SearchScreenReusableHeader.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/26/21.
//

import UIKit

final class SearchScreenReusableHeader: UICollectionReusableView, ReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
