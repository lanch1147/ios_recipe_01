//
//  RecipeRequest.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/14/21.
//

import Foundation

struct RecipeRequest: APIRequest {
    typealias Response = RecipeResponse

    enum Field: String, CaseIterable {
        case uri
        case label
        case image
        case source
        case url
        case calories
        case totalNutrients
        case ingredientLines
        
        func toQueryItem() -> URLQueryItem {
            return URLQueryItem(name: "field", value: self.rawValue)
        }
    }
    
    private let baseComponent = BaseComponentProvider.shared.createBaseComponents()
    var recipeName: String?
    var categories: [Category]
    var selectedFields: [Field]
    var urlRequest: URLRequest {
        var components = baseComponent
        if let recipeName = recipeName {
            components.queryItems?.append(URLQueryItem(name: "q", value: recipeName))
        }
        categories.forEach { components.queryItems?.append($0.toQueryItem()) }
        selectedFields.forEach { components.queryItems?.append($0.toQueryItem()) }
        
        guard let url = components.url else {
            fatalError("Invalid query items")
        }
        return URLRequest(url: url)
    }
    
    init(recipeName: String? = nil, categories: [Category] = [], selectedFields: [Field] = Field.allCases) {
        self.recipeName = recipeName
        self.categories = categories
        self.selectedFields = selectedFields
    }
    
    func decodeResponse(from data: Data) throws -> RecipeResponse {
        let decodedData = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return decodedData
    }
}
