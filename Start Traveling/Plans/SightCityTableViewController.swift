//
//  SightCityTableViewController.swift
//  Start Traveling
//
//  Created by Xinbei Li on 6/6/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit
import CoreData

class SightCityTableViewController: UITableViewController {
    var city:Cities?
    var plan:Plan?
    var sights=[Sights]()
    var databaseController: DatabaseProtocol?
    
    //this func would pass the data to map to select sights
    @IBAction func add(_ sender: Any) {
        if(city?.name==nil){
            return
        }
        UserDefaults.standard.set(city?.name, forKey: "cityToAddNewSights")
        UserDefaults.standard.set(true,forKey: "AddToAnExistingPlan?")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title=city!.name
        sights=city?.sights?.allObjects as! [Sights]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sights.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sightCell", for: indexPath)
        let sightCell:SightCityTableViewCell=cell as! SightCityTableViewCell
        sightCell.name.text=sights[indexPath.row].name
        return cell
    }
    override func viewDidAppear(_ animated: Bool) {
        //If there's something changed in the database, reload data
        city=databaseController?.fetchCityInPlan(planName: plan!.tittle!, targetName: city!.name!)
        if (city?.sights != nil) {
            sights=city?.sights?.allObjects as! [Sights]
            tableView.reloadData()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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


   //this func would pass the data to the map to generate the map and select sights
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="addNewSights"){
            //let controller:MapViewController=segue.destination as! MapViewController
            if(city?.name==nil){
                return
            }
            //send data to map
            UserDefaults.standard.set(plan?.tittle, forKey: "passedPlan")
            UserDefaults.standard.set(city?.name, forKey: "cityToAddNewSights")
            UserDefaults.standard.set(true,forKey: "AddToAnExistingPlan?")
            //controller.passedCity=city
        }
    }


}
