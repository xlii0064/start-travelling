//
//  SelectRecommendationTableViewController.swift
//  Start Traveling
//
//  Created by Xinbei Li on 26/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps

class SelectRecommendationTableViewController: UITableViewController {
    var cities=[String]()
    var databaseController: DatabaseProtocol?
    private let dataProvider=GoogleDataProvider()
     var placeType=["zoo","aquarium","museum","art_gallery","church","park","amusement_park"]

    //LOAD DATA
    override func viewDidLoad() {
        super.viewDidLoad()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            databaseController = appDelegate.databaseController
            cities=["Melbourne","Sydney","Brisbane","Adelaide","Perth","Canberra","Darwin","Hobart","Cairns","Gold Coast","Newcastle","Wollongong"]
    }
    

    // MARK: - Table view data source

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

        let cityCell: SelectRecommendationTableViewCell = cell as! SelectRecommendationTableViewCell
        let current=cities[indexPath.row]
        cityCell.city.text=current
    
        

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


   
    // this func would pass the selected city to the next tableview controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="details"){
            let controller:SamplePlanTableViewController=segue.destination as! SamplePlanTableViewController
            let selectedIndexPath = tableView.indexPathsForSelectedRows?.first
            controller.city = cities[selectedIndexPath!.row]
            

    }
    }


}
