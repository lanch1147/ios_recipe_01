//
//  UIViewController+.swift
//  Recipe Search
//
//  Created by Lan Chu on 10/4/21.
//

import Foundation
import UIKit

extension UIViewController {
    func presentBasicAlert(withTitle title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
