//
//  RecipeDetailViewController.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/24/21.
//

import UIKit

final class RecipeDetailViewController: UIViewController {
    private var recipe: Recipe
    
    init?(coder: NSCoder, recipe: Recipe) {
        self.recipe = recipe
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
