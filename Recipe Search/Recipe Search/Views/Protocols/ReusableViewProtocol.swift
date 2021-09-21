//
//  ReusableViewProtocol.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/21/21.
//

import Foundation
import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
