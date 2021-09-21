//
//  UISearchBar+Extension.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/21/21.
//

import Foundation
import UIKit

extension UISearchBar {
    func setClearButtonColor(with color: UIColor) {
        let clearButton = searchTextField.value(forKey: "clearButton") as? UIButton
        clearButton?.setImage(clearButton?.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton?.tintColor = color
    }
    
    private func calculatePlaceholderWidth() -> CGFloat {
        let text = searchTextField.placeholder as NSString?
        let textFont: UIFont
        if let attPlaceholder = searchTextField.attributedPlaceholder,
           let placeholderFont = attPlaceholder.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
            textFont = placeholderFont
        } else if let font = searchTextField.font {
            textFont = font
        } else {
            textFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        }
    
        let textWidth = text?.size(withAttributes: [.font: textFont]).width ?? 0
        return textWidth
    }
    
    func centerPlaceholder() {
        let adjustment: CGFloat = 10
        
        let searchFieldWidth = searchTextField.bounds.width
        var leftViewWidth = searchTextField.leftView?.bounds.width ?? 0
        leftViewWidth += positionAdjustment(for: .search).horizontal
        let placeholderWidth = calculatePlaceholderWidth()
        let padding: CGFloat = (searchFieldWidth - placeholderWidth)/2 - leftViewWidth - adjustment

        searchTextPositionAdjustment = UIOffset(horizontal: padding, vertical: 0)
    }
}
