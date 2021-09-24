//
//  HomeScreenReusableHeaderDelegate.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/24/21.
//

import Foundation

protocol HomeScreenReusableHeaderDelegate: AnyObject {
    func didPressViewAllButton(sender: HomeScreenReusableHeader, at indexPath: IndexPath)
}
