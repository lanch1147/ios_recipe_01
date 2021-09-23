//
//  Categories.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/17/21.
//

import Foundation

protocol Category {
    var rawValue: String { get }
    func toQueryItem() -> URLQueryItem
    func name() -> String
}

extension Category {
    func name() -> String {
        return rawValue.capitalized
    }
}

enum Meal: String, CaseIterable, Category {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    case teatime = "Teatime"
    
    func toQueryItem() -> URLQueryItem {
        return URLQueryItem(name: "mealType", value: self.rawValue)
    }
}

enum DishType: String, CaseIterable, Category {
    case alcoholCocktail = "Alcohol-cocktail"
    case biscuitAndCookies = "Biscuits and cookies"
    case bread = "Bread"
    case cereals = "Cereals"
    case condimentsAndSauces = "Condiments and sauces"
    case drinks = "Drinks"
    case desserts = "Desserts"
    case egg = "Egg"
    case mainCourse = "Main course"
    case omelet = "Omelet"
    case pancake = "Pancake"
    case preps = "Preps"
    case preserve = "Preserve"
    case salad = "Salad"
    case sandwiches = "Sandwiches"
    case soup = "Soup"
    case starter = "Starter"
    
    func toQueryItem() -> URLQueryItem {
        return URLQueryItem(name: "dishType", value: self.rawValue)
    }
}

enum Cuisine: String, CaseIterable, Category {
    case american = "American"
    case asian = "Asian"
    case bristish = "British"
    case caribbean = "Caribbean"
    case centralEurope = "Central Europe"
    case chinese = "Chinese"
    case easternEurope = "Eastern Europe"
    case french = "French"
    case indian = "Indian"
    case italian = "Italian"
    case japanese = "Japanese"
    case kosher = "Kosher"
    case mediterranean = "Mediterranean"
    case mexican = "Mexican"
    case middleEastern = "Middle Eastern"
    case nordic = "Nordic"
    case southAmerican = "South American"
    case southEastAsian = "South East Asian"
    
    func toQueryItem() -> URLQueryItem {
        return URLQueryItem(name: "cuisineType", value: self.rawValue)
    }
}
