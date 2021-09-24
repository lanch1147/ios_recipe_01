//
//  HomeScreenReusableHeader.swift
//  Recipe Search (Demo)
//
//  Created by Lan Chu on 9/10/21.
//

import UIKit

class HomeScreenReusableHeader: UICollectionReusableView, ReusableView {
    @IBOutlet private weak var titleHeader: UILabel!
    var indexPath: IndexPath?
    weak var delegate: HomeScreenReusableHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with title: String, at indexPath: IndexPath) {
        titleHeader.text = title
        self.indexPath = indexPath
    }
    
    @IBAction func viewAllButtonPressed(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        delegate?.didPressViewAllButton(sender: self, at: indexPath)
    }
}
