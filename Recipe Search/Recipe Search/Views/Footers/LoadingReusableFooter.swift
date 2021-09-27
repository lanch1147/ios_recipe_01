//
//  LoadingReusableFooter.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/24/21.
//

import UIKit

final class LoadingReusableFooter: UICollectionReusableView, ReusableView {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
}
