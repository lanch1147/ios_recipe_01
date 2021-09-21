//
//  UICollectionView+Extension.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/21/21.
//

import Foundation
import UIKit

extension UICollectionView {
    func registerSupplementaryView<View>(ofType: View.Type, forKind kind: String)
    where View: ReusableView, View: UICollectionReusableView {
        register(View.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: View.reuseIdentifier)
    }
    
    func registerCell<Cell>(ofType: Cell.Type) where Cell: ReusableView, Cell: UICollectionViewCell {
        register(Cell.nib, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func dequeueCell<Cell>(ofType type: Cell.Type, at indexPath: IndexPath) -> Cell
    where Cell: ReusableView, Cell: UICollectionViewCell {
        let identifier = Cell.reuseIdentifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell
        else {
            fatalError("""
                        Expected \(Cell.self) type for reuseIdentifier \(identifier).\
                        Check the configuration in Main.storyboard.
                        """)
        }
        return cell
    }
    
    func dequeueView<View>(ofType type: View.Type, forKind kind: String, at indexPath: IndexPath) -> View
    where View: ReusableView, View: UICollectionReusableView {
        let identifier = View.reuseIdentifier
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier,
                                                                         for: indexPath) as? View
        else {
            fatalError("""
                        Expected \(View.self) type for reuseIdentifier \(identifier).\
                        Check the configuration in Main.storyboard.
                        """)
        }
        return view
    }
}
