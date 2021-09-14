//
//  RecipeAPIResponse.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/14/21.
//

import Foundation

struct RecipeResponse: Decodable {
    var startIndex: Int
    var endIndex: Int
    var total: Int
    var recipes: [Recipe]
    var nextPageURL: URL?
    
    enum OuterKeys: String, CodingKey {
        case startIndex = "from"
        case endIndex = "to"
        case total = "count"
        case recipes = "hits"
        case outerNextPageContainer = "_links"
    }
    
    enum NextPageURLKey: String, CodingKey {
        case innerNextPageContainer = "next"
        case nextPageURL = "href"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OuterKeys.self)
        
        startIndex = try container.decode(Int.self, forKey: .startIndex)
        endIndex = try container.decode(Int.self, forKey: .endIndex)
        total = try container.decode(Int.self, forKey: .total)
        recipes = try container.decode([Recipe].self, forKey: .recipes)
        
        let outerNextPageContainer = try container.nestedContainer(keyedBy: NextPageURLKey.self,
                                                                   forKey: .outerNextPageContainer)
        let innerNextPageContainer = try outerNextPageContainer.nestedContainer(
            keyedBy: NextPageURLKey.self, forKey: .innerNextPageContainer)
        nextPageURL = try innerNextPageContainer.decode(URL?.self, forKey: .nextPageURL)
    }
}
