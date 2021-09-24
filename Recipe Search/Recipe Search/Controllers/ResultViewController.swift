//
//  ResultViewController.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/24/21.
//

import UIKit

final class ResultViewController: UIViewController {
    private var recipeResponse: RecipeResponse
    
    init?(coder: NSCoder, recipeResponse: RecipeResponse) {
        self.recipeResponse = recipeResponse
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
