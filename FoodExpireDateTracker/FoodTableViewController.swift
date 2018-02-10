//
//  FoodTableViewController.swift
//  FoodExpireDateTracker
//
//  Created by Fang Yang on 4/2/18.
//  Copyright © 2018 Yang Fang. All rights reserved.
//

import UIKit
import os.log

class FoodTableViewController: UITableViewController {
    
    //MARK: Properties
    var foods = [Food]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem

        if let savedFoods = loadFoods() {
            foods += savedFoods
            foods.sort{
                $0.date < $1.date
            }
        }else{
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foods.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndentifier = "FoodTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? FoodTableViewCell else{
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let food = foods[indexPath.row]
        cell.nameLabel.text = food.name
        cell.dateLabel.text = food.date
        cell.photoImageView.image = food.photo

        // Configure the cell...

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            foods.remove(at: indexPath.row)
            saveFoods()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new food.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let foodDetailViewController = segue.destination as? FoodViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedFoodCell =  sender as? FoodTableViewCell else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let indexPath = tableView.indexPath(for: selectedFoodCell) else{
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedFood = foods[indexPath.row]
            foodDetailViewController.food = selectedFood
        default:
            fatalError("Unexpected Segue Indentifier; \(String(describing: segue.identifier))")
        }
    }
    
    @IBAction func unwindToFoodList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? FoodViewController, let food = sourceViewController.food {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                foods[selectedIndexPath.row] = food
                foods.sort{
                    $0.date < $1.date
                }
                /*tableView.reloadRows(at: [selectedIndexPath], with: .none)*/
                tableView.reloadData()
            }else{
                let newIndexPath = IndexPath(row: foods.count, section: 0)
                foods.append(food)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                foods.sort{
                    $0.date < $1.date
                }
                tableView.reloadData()
            }
            saveFoods()
        }
    }

    private func saveFoods(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(foods, toFile: Food.ArchiveURL.path)
        if isSuccessfulSave{
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        }
        else{
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadFoods() -> [Food]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Food.ArchiveURL.path) as? [Food]
    }
}
