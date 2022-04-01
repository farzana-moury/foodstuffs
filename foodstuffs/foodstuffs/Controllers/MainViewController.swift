//
//  ViewController.swift
//  foodstuffs
//
//  Created by Farzana Moury on 2022-03-31.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Properties
    var foodItem: FoodItem!
    var foodStore: FoodStore!
    
    //MARK: - IBOutlets
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var groceryList: UITableView!
    
    //MARK: - IBActions
    @IBAction func addFood(_ sender: UIBarButtonItem) {
        //adding an alert controller
        let alertController = UIAlertController(title: "Add Grocery Item", message: "Enter a foodstuff!", preferredStyle: .alert)
        
        //adding a textfield to the alert
        alertController.addTextField()
        
        //setting the actions of the alert controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {
            [weak self] _ in // weak self - it is not going to capture a hold of any of the properties we access in here
            
            //we will safely access the textfield text
            guard let textField = alertController.textFields?[0], let text = textField.text, !text.isEmpty else {
                return
            }
            
            let newFoodItem = FoodItem(foodItem: text)
            
            self?.foodStore.addFoodItem(item: newFoodItem)
    
            //reload the tableView (aka grocery list)
            self?.groceryList.reloadData()
        })
        
        //adding actions and presenting the alert
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodStore = FoodStore()
        groceryList.delegate = self
        groceryList.dataSource = self
        
    }
}

//MARK: - extensions

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: UITableViewDataSource {
    
    //MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //the total number of rows
        return foodStore.foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //referencing the table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodstuff", for: indexPath)
        
        //setting the fodd item in the cell
        let item = foodStore.foodItems[indexPath.row]
        
        cell.textLabel?.text = item.foodItem
        
        return cell
    }
}
