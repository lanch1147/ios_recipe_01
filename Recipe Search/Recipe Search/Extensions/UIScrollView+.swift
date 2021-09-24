//
//  UIScrollView+.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/24/21.
//

import Foundation
import UIKit

extension UIScrollView {
    func didScrollTo(offsetFromBottom: CGFloat) -> Bool {
        let offsetY = contentOffset.y
        let contentHeight = contentSize.height
        let frameHeight = frame.size.height
        return offsetY > contentHeight - frameHeight - offsetFromBottom
    }
}
