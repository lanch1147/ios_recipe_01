//
//  UIImage+.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/23/21.
//

import Foundation
import UIKit

extension UIImageView {
    func load(with url: URL) {
        UIImageLoader.shared.load(url, for: self)
    }
    
    func cancelRemainingLoadingTask() {
        UIImageLoader.shared.cancel(for: self)
    }
}
