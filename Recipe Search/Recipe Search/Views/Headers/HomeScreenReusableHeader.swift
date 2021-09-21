//
//  HomeScreenReusableHeader.swift
//  Recipe Search (Demo)
//
//  Created by Lan Chu on 9/10/21.
//

import UIKit

class HomeScreenReusableHeader: UICollectionReusableView, ReusableView {
    @IBOutlet private weak var titleHeader: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with title: String) {
        titleHeader.text = title
    }
}
