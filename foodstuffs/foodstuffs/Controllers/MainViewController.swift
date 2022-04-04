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
    var total: Int = 0
    
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
            
            self?.foodItem = FoodItem(foodItem: text)
            
            self?.foodStore.addFoodItem(item: self?.foodItem ?? FoodItem(foodItem: "Default"))
    
            //reload the tableView (aka grocery list)
            self?.groceryList.reloadData()
            
            //resetting the progress label if we have completed the list
            if(self?.total == 0){
                self?.progressBar.setProgress(0, animated: false)
            }
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
        
        //loading the items that were saved
        foodStore.loadFoodItem()
        
        groceryList.delegate = self
        groceryList.dataSource = self
        
        total = foodStore.foodItems.count
        
        //setting the progress if we still have foodstuffs to check off
        if total != 0 {
            progressBar.setProgress(Float(1 / Double(total + 1)), animated: false)
        }else{
            progressBar.setProgress(0, animated: false)
        }
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
        
        //setting the food item in the cell
        foodItem = foodStore.foodItems[indexPath.row]
        
        cell.textLabel?.text = foodItem.foodItem
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let completeAction = UIContextualAction(style: .normal, title: "Complete", handler: { (action, view, completion) in
            
            self.foodItem = self.foodStore.foodItems[indexPath.row]
            self.foodStore.removeFoodItem(item: self.foodItem)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.total = self.foodStore.foodItems.count
            self.progressBar.setProgress(Float(1 / Double(self.total + 1)), animated: false)
            
            //if all of our foodstuffs have been checked off our grocery list
            if self.total == 0 {
                //adding an alert controller
                let alertController = UIAlertController(title: "Congratulations! 🎉", message: "You completed your grocery list 🐰", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Awesome!", style: .cancel, handler: nil)
                
                alertController.addAction(action)
            
                self.present(alertController, animated: true)
            }
            
            completion(true)
        })
        completeAction.backgroundColor = .systemGreen
        
        let config = UISwipeActionsConfiguration(actions: [completeAction])
        return config
    }
}
