//
//  SamplePlanTableViewController.swift
//  Start Traveling
//
//  Created by Xinbei Li on 26/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

class SamplePlanTableViewController: UITableViewController {
    var databaseController: DatabaseProtocol?
    var city:String?
    var placeList=[String]()
    private let dataProvider=GoogleDataProvider()
    var placeType=["zoo","aquarium","museum","art_gallery","church","park","amusement_park"]
    private var placesTask: URLSessionDataTask?
    
    //this function handles the save button which would save the current plan into the database and pop back
    @IBAction func save(_ sender: Any) {
        let today=Date()
        let sample=databaseController?.addPlan(tittle: city!+" Sample", author: "default", start: today)
        let sampleCity=databaseController?.addCities(name: city!)
        let _=databaseController?.addCitiesToPlan(city: sampleCity!, plan: sample!)
        for names in placeList{
            let _=databaseController?.addSightsToCity(sight: (databaseController?.addSights(name: names))!, city: sampleCity!)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
   
    private var session: URLSession {
        return URLSession.shared
    }
    //this function loads the data from the list into the tableview
    override func viewDidLoad() {
        super.viewDidLoad()
        title=city
        loadSights()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    //this function load the sights of the corresponding city from he google place API. This function was original
    //developed by an online tutorial
    func loadSights(){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city!) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location
                    for type in self.placeType{
                    self.fetchPlacesNearCoordinate(location!.coordinate, radius:Double(10000), types:[type]) { places in
                        places.forEach {place in
                            
                            self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    //this function loads sights using Google place API which was originally from an online tutorial
    func fetchPlacesNearCoordinate(_ coordinate: CLLocationCoordinate2D, radius: Double, types: [String], completion: @escaping PlacesCompletion) -> Void {
        var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true&key=\(googleApiKey)"
        let typesString = types.count > 0 ? types.joined(separator: "|") : "museum"
        urlString += "&types=\(typesString)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
            task.cancel()
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        placesTask = session.dataTask(with: url) { data, response, error in
            var placesArray: [GooglePlace] = []
            defer {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion(placesArray)
                }
            }
            guard let data = data,
                let json = try? JSON(data: data, options: .mutableContainers),
                let results = json["results"].arrayObject as? [[String: Any]] else {
                    return
            }
            results.forEach {
                let place = GooglePlace(dictionary: $0, acceptedTypes: types)
                placesArray.append(place)
                self.placeList.append(place.name)
            }
        }
        placesTask?.resume()
    }
    //

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placeList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sightCell", for: indexPath)
        let sightCell: SamplePlanTableViewCell = cell as! SamplePlanTableViewCell
        sightCell.name.text=placeList[indexPath.row]       
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
