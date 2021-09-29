//
//  NutrientSectionReusableFooter.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/28/21.
//

import UIKit

final class NutrientSectionReusableFooter: UICollectionReusableView, ReusableView {
    @IBOutlet private weak var cookButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cookButton.layer.cornerRadius = 10
    }
}
