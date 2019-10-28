//
//  HistoryPlansTableViewController.swift
//  Start Traveling
//
//  Created by Xinbei Li on 30/4/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit
import CoreData

class HistoryPlansTableViewController: UITableViewController {
    var plans=[Plan]()
    var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        plans.removeAll()
        loadData()
        tableView.reloadData()
    }
    
    //this function would load all the saved plans from the database
    func loadData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Plan")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                plans.append(data as! Plan)
            }
            
        } catch {
            
            print("Failed")
        }
        
        appDelegate.saveContext()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return plans.count
        
    }

    //this func would generate the cell and calculate how many days left before starting the plan
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath)

        let planCell:HistoryPlansTableViewCell=cell as! HistoryPlansTableViewCell
        planCell.name.text=plans[indexPath.row].tittle
        //calculate the days left and forat it
        let format=DateFormatter()
        format.dateFormat="yyyy-MM-dd"
        let goDate=format.string(from: plans[indexPath.row].startDate! as Date)
        planCell.date.text=goDate
        let today=Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: today, to: plans[indexPath.row].startDate! as Date)
        let days=components.day
        planCell.status.text=String(days!)+" day(s) left"

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            databaseController = appDelegate.databaseController
            databaseController!.deletePlan(plan: plans[indexPath.row])
            plans.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            tableView.reloadData()
         
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

    
    //This func would pass the selected plan to the next viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="planDetails"){
            let controller:PlanDetailsTableViewController=segue.destination as! PlanDetailsTableViewController
            let selectedIndexPath = tableView.indexPathsForSelectedRows?.first
            controller.plan = plans[selectedIndexPath!.row]
        }
    }
    

}

