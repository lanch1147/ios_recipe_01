//
//  CoreDataManager.swift
//  Recipe Search
//
//  Created by Lan Chu on 10/1/21.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecipeSearch")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unable to load persistent stores: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return container.viewContext
    }()
    
    private init() {}
    
    private func fetchRecipeModels(with request: NSFetchRequest<RecipeCoreData> = RecipeCoreData.fetchRequest()) -> [RecipeCoreData] {
        do {
            let result = try context.fetch(request)
            return result
        } catch let error as NSError {
            fatalError("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    private func fetchRecipeModel(with identifier: String) -> RecipeCoreData? {
        let request: NSFetchRequest<RecipeCoreData> = RecipeCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(RecipeCoreData.identifier), identifier)
        return fetchRecipeModels(with: request).first
    }
    
    func isStored(recipeID: String) -> Bool {
        return fetchRecipeModel(with: recipeID) != nil
    }
    
    func fetchAllRecipes() -> [Recipe] {
        let recipeModels = fetchRecipeModels()
        let recipes = recipeModels.map { Recipe(from: $0) }
        return recipes
    }
    
    private func createRecipeCoreDataModel(_ recipe: Recipe) {
        let newModel = RecipeCoreData(context: context)
        newModel.identifier = recipe.identifier
        newModel.name = recipe.name
        newModel.imageURL = recipe.imageURL
        newModel.sourceName = recipe.sourceName
        newModel.sourceURL = recipe.sourceURL
        newModel.defaultNumServings = Int16(recipe.defaultNumServings)
        recipe.ingredients.forEach {
            newModel.addToIngredients(self.createIngredientCoreDataModel($0))
        }
        recipe.nutrients.forEach {
            newModel.addToNutrients(self.createNutrientCoreDataModel($0))
        }
    }
    
    private func createIngredientCoreDataModel(_ ingredient: String) -> IngredientCoreData {
        let newModel = IngredientCoreData(context: context)
        newModel.detail = ingredient
        return newModel
    }
    
    private func createNutrientCoreDataModel(_ nutrient: Nutrient) -> NutrientCoreData {
        let newModel = NutrientCoreData(context: context)
        newModel.name = nutrient.name
        newModel.quantity = nutrient.quantity
        newModel.unit = nutrient.unit
        return newModel
    }
    
    func save(recipe: Recipe) throws {
        guard !isStored(recipeID: recipe.identifier) else { return }
        createRecipeCoreDataModel(recipe)
        try context.save()
    }
    
    private func deleteRecipeModel(_ model: RecipeCoreData) {
        context.delete(model)
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Saving error: \(error), \(error.userInfo)")
        }
    }
    
    func delete(recipeID: String) {
        if let toDeleteModel = fetchRecipeModel(with: recipeID) {
            deleteRecipeModel(toDeleteModel)
        }
    }
}
