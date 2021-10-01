//
//  RecipeAPIModel.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/14/21.
//

import Foundation

struct Recipe {
    var identifier: String
    var name: String
    var imageURL: URL?
    var sourceName: String
    var sourceURL: URL?
    var defaultNumServings: Int
    var ingredients: [String]
    var nutrients = [Nutrient]()
}

extension Recipe: Decodable {
    enum OuterKeys: String, CodingKey {
        case recipeContainer = "recipe"
    }
    
    enum RecipeKeys: String, CodingKey {
        case identifier = "uri"
        case name = "label"
        case imageURL = "image"
        case sourceName = "source"
        case sourceURL = "url"
        case defaultNumServings = "yield"
        case ingredients = "ingredientLines"
        case nutrientContainer = "totalNutrients"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OuterKeys.self)
        
        let recipeContainer = try container.nestedContainer(keyedBy: RecipeKeys.self, forKey: .recipeContainer)
        identifier = try recipeContainer.decode(String.self, forKey: .identifier)
        name = try recipeContainer.decode(String.self, forKey: .name)
        imageURL = try recipeContainer.decode(URL?.self, forKey: .imageURL)
        sourceName = try recipeContainer.decode(String.self, forKey: .sourceName)
        sourceURL = try recipeContainer.decode(URL?.self, forKey: .sourceURL)
        defaultNumServings = try recipeContainer.decode(Int.self, forKey: .defaultNumServings)
        ingredients = try recipeContainer.decode([String].self, forKey: .ingredients)
        
        let nutrientContainer = try recipeContainer.nestedContainer(keyedBy: Nutrient.NutrientOuterKeys.self,
                                                                    forKey: .nutrientContainer)
        for key in Nutrient.NutrientOuterKeys.allCases {
            let nutrient = try nutrientContainer.decode(Nutrient.self, forKey: key)
            nutrients.append(nutrient)
        }
    }
}

extension Recipe {
    init(from model: RecipeCoreData) {
        identifier = model.identifier ?? ""
        name = model.name ?? ""
        imageURL = model.imageURL
        sourceName = model.sourceName ?? ""
        sourceURL = model.sourceURL
        defaultNumServings = Int(model.defaultNumServings)
        let ingredientModels = model.ingredients?.array as? [IngredientCoreData] ?? []
        let nutrientModels = model.nutrients?.array as? [NutrientCoreData] ?? []
        ingredients = ingredientModels.map { $0.detail ?? "" }
        nutrients = nutrientModels.map {
            Nutrient(from: $0)
        }
    }
}
