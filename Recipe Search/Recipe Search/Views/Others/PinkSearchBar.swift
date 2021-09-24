//
//  PinkSearchBar.swift
//  CustomizeSearchBar
//
//  Created by Lan Chu on 9/11/21.
//

import UIKit

class PinkSearchBar: UISearchBar {
    
    override func draw(_ rect: CGRect) {
        searchTextField.backgroundColor = .systemPink
        searchTextField.leftView?.tintColor = .white
        searchTextField.rightView?.tintColor = .white
        tintColor = .white
        searchTextField.textColor = .white
        setClearButtonColor(with: .white)
        
        let searchFieldHeight = searchTextField.frame.height
        searchTextField.layer.cornerRadius = searchFieldHeight / 2
        searchTextField.clipsToBounds = true
        
        let padding: CGFloat = 8
        let leftOffset = UIOffset(horizontal: padding, vertical: 0)
        let rightOffset = UIOffset(horizontal: -padding, vertical: 0)
        setPositionAdjustment(leftOffset, for: .search)
        setPositionAdjustment(rightOffset, for: .clear)
    }
}
