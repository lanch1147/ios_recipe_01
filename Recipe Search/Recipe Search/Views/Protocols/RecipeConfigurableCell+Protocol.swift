//
//  RecipeConfigurableCell+Protocol.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/21/21.
//

import Foundation
import UIKit

protocol RecipeConfigurableCell: UICollectionViewCell {
    func configure(with recipe: Recipe)
}
