//
//  SelectedFilterCollectionViewCellDelegate.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/27/21.
//

import Foundation

protocol SelectedFilterCollectionViewCellDelegate: AnyObject {
    func didSelectRemoveButton(at cell: SelectedFilterCollectionViewCell)
}
