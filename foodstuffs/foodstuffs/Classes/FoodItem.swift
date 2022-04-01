//
//  FoodItem.swift
//  foodstuffs
//
//  Created by Farzana Moury on 2022-03-31.
//

import UIKit

class FoodItem: Codable, Hashable {
    
    static func == (lhs: FoodItem, rhs: FoodItem) -> Bool {
        return lhs.itemID == rhs.itemID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(itemID)
    }
    
    var itemID: String
    var foodItem: String
    
    init(foodItem: String){
        self.itemID = UUID().uuidString
        self.foodItem = foodItem
    }
    
    
}
