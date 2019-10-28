//
//  ChooseCitiesTableViewController.swift
//  Start Traveling
//
//  Created by Xinbei Li on 4/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit
import CoreData

class ChooseCitiesTableViewController: UITableViewController {
    var plan:Plan?
    var cities=[Cities]()
    var selected=[Bool]()
    var databaseController: DatabaseProtocol?
    
    //this func load all the possible cities to be selected by the user
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (cities.count==0){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        let temp=["Melbourne","Sydney","Brisbane","Adelaide","Perth","Canberra","Darwin","Hobart","Cairns","Gold Coast","Newcastle","Wollongong"]
            for name in temp{
                cities.append(((databaseController?.addCities(name: name))!))
                selected.append(false);
            }
        }
        else{
            var index=0
            while index<cities.count{
                selected.append(false)
                index+=1
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @IBAction func next(_ sender: Any) {
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let cityCell: ChooseCitiesTableViewCell = cell as! ChooseCitiesTableViewCell
        cityCell.name.text=cities[indexPath.row].name

        return cell
    }
    
    //this func enables the check mark. If the row was selected for the second time, the check mark would disappear
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                //if the cell was tapped a second time, remove the check mark
                cell.accessoryType = .none
                selected[indexPath.row]=false
            } else {
                cell.accessoryType = .checkmark
                selected[indexPath.row]=true
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    //this func is to generate a city list to pass based on the results in the selected list
    func generatePassList() -> [Cities] {
        var returnList = [Cities]()
        var index=0
        while index<selected.count {
            if selected[index]{
                returnList.append(cities[index])
            }
            index+=1
        }
        return returnList
    }

    // this func would pass the current plan and the selected city list to the next table viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="setOrderSegue"{
            UserDefaults.standard.set(true, forKey: "newPlan?")
            let controller:SetOrderTableViewController=segue.destination as! SetOrderTableViewController
            let newList=generatePassList()
            controller.cities=newList
            controller.plan=plan
            
        }
    }
    

}
