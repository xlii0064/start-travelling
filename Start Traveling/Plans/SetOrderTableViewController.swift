//
//  SetOrderTableViewController.swift
//  Start Traveling
//
//  Created by Xinbei Li on 7/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit

class SetOrderTableViewController: UITableViewController {

    var plan:Plan?
    var INPUT_SECTION=1
    var TITTLE_SECTION=0
    var cities=[Cities]()
    var checked=[Bool]()
    var databaseController: DatabaseProtocol?
    var sightList=[String]()
    
    var previousCity:Cities?
    var previousPlan:Plan?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
       
    }
    
    //this func would check if the plan is a new plan or not first. If the plan is new, it would not process further since it would not have a sight list to be added.
    //Else it would get the selected sights and compare the current city name with the previous city name. If they are the same, add the new sights into the city, else, create a new city in this plan add then add sights inside
    override func viewDidAppear(_ animated: Bool) {
        var temp=[String]()
        if (UserDefaults.standard.bool(forKey: "newPlan?")){
            previousPlan=plan
            UserDefaults.standard.set(false, forKey: "newPlan?")
            return 
        }
        //Error handling for no sightlist
        if (UserDefaults.standard.array(forKey: "sightList")==nil){
            return
        }
        temp=UserDefaults.standard.array(forKey: "sightList") as! [String]
        let city=UserDefaults.standard.string(forKey: "mapCityName")
        if (temp.count==0){
            print("No new sights was selected")
            return
        }
        //if it's a new city that doesn't exist in the database yet, it would be created first and add sights to it
        if (temp != sightList && city != previousCity?.name){
            let newCity=databaseController?.addCities(name: city!)
            databaseController?.addCitiesToPlan(city: newCity!, plan: plan!)
            previousCity=newCity
            for sight  in temp{
                databaseController?.addSightsToCity(sight: (databaseController?.addSights(name: sight))!, city: newCity!)
            }
            return
        }
        //if it's not a new city, the sights would be added directly
        if (temp != sightList && city == previousCity?.name){
            for sight  in temp{
                databaseController?.addSightsToCity(sight: (databaseController?.addSights(name: sight))!, city: previousCity!)
            }
            
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==TITTLE_SECTION{
            return 1
        }
        else{
            return cities.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==INPUT_SECTION{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cities_cell", for: indexPath)
        let cityCell: SetOrderTableViewCell = cell as! SetOrderTableViewCell
        cityCell.name.text!=cities[indexPath.row].name!
        cityCell.cityName=cities[indexPath.row].name!
        cityCell.parent = self
            cityCell.indexPath = indexPath
        
        return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "display_cell", for: indexPath)
        
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
        if editingStyle == .delete {letgo
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

   
    //handle the done button by poping the view to the root view controller
    @IBAction func pop(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
/*
    // MARK: - Navigation
        var des: UIViewController?
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="selectSights"){
            des = segue.destination as! MapViewController
          let controller:MapViewController=segue.destination as! MapViewController


        }
    }
*/

}
