//
//  FoodStore.swift
//  foodstuffs
//
//  Created by Farzana Moury on 2022-03-31.
//

import UIKit

class FoodStore {
    
    var foodItems = [FoodItem]()
    
    var documentDirectory:URL?{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }
    
    func removeFoodItem(item: FoodItem){
        for (index, foodItem) in foodItems.enumerated(){
            if foodItem == item {
                foodItems.remove(at: index)
            }
        }
        saveFoodItems()
    }
    
    func saveFoodItems(){
        guard let docDirectory = documentDirectory else { return }
        
        let fileName = docDirectory.appendingPathComponent("groceryList.json")
        
        saveJson(to: fileName)
    }
    
    func saveJson(to url: URL) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let jsonData  = try encoder.encode(foodItems)
            try jsonData.write(to: url)
            
        } catch {
            print("Unable to save the JSON - \(error.localizedDescription)")
        }
    }
    
    func loadFoodItem(){
        guard let docDirectory = documentDirectory else { return }
        
        let fileName = docDirectory.appendingPathComponent("groceryList.json")
        
        loadJSON(from: fileName)
    }
    
    func loadJSON(from url: URL){
        do{
            let jsonData = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            
            let results = try decoder.decode([FoodItem].self, from: jsonData)
            
           foodItems = results
            
        } catch{
            print("Unable to load the JSON - \(error.localizedDescription)")
            
        }
    }
}
