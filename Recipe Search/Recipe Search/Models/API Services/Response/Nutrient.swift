//
//  NutrientAPIModel.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/14/21.
//

import Foundation

struct Nutrient: Decodable {
    var name: String
    var quantity: Double
    var unit: String
    
    enum CodingKeys: String, CodingKey {
        case name = "label"
        case quantity
        case unit
    }
    
    enum NutrientOuterKeys: String, CodingKey, CaseIterable {
        case calories = "ENERC_KCAL"
        case fat = "FAT"
        case carb = "CHOCDF"
        case fiber = "FIBTG"
        case sugar = "SUGAR"
        case protein = "PROCNT"
        case cholesterol = "CHOLE"
        case water = "WATER"
    }
}
