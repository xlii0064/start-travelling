//
//  MapViewController.swift
//  Start Traveling
//
//  Created by Xinbei Li on 7/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import CoreData

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    var databaseController: DatabaseProtocol?
    var city:String?
    var selected:String?
    var sightList = [String]()
    var placeType=["zoo","aquarium","museum","art_gallery","church","park","amusement_park"]
    private let locationManager=CLLocationManager()
    private let dataProvider=GoogleDataProvider()
    private let radius=10000
    
    var passedCity:Cities?
    var passedPlan:Plan?
    
    //this func would check if the plan already exists or not, if so, it will get data from the SightCityTableViewController, else, it will get data from the setOrderTableViewController. Then it would decode the city name inside it and fetch the nearby sights using Google place API
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        mapView.delegate=self
        if (UserDefaults.standard.bool(forKey: "AddToAnExistingPlan?")){
            city=UserDefaults.standard.string(forKey: "cityToAddNewSights")
           
        }else{
        city=UserDefaults.standard.string(forKey: "mapCityName")
        }
        //decode the city name that was passed into the map
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city!) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location
                    self.mapView.camera = GMSCameraPosition(target: location!.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
                    
                    self.fetchNearbyPlaces(coordinate: location!.coordinate)
                    }
            }
        }
    }
    
    //this func would mark the sigths that was fetched from the Google place API on the map
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        for type in placeType{
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:Double(radius), types:[type]) { places in
            places.forEach {place in
                let marker = PlaceMarker(place:place)
                marker.map = self.mapView
            }
        }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    //this func would see if the sightList was to be added into an existing plan or not. If so, it would get data from sightCityTableViewController and fetch the city accordingly. Then it would check if the sightList has any duplicate element and then add the identical ones into the city. Else it would send the data back to the SetOrderTableViewController and pop back. 
    @IBAction func done(_ sender: Any) {
        //report error when the user wants to store empty sight list
        if (sightList.count==0){
            let alert=UIAlertController(title:"Warning!",message:"Empty sight list is not allowed",preferredStyle:UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler:nil) )
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (UserDefaults.standard.bool(forKey: "AddToAnExistingPlan?")){
            UserDefaults.standard.set(false, forKey: "AddToAnExistingPlan?")
            let passedCityName=UserDefaults.standard.string(forKey: "cityToAddNewSights")
            passedCity = databaseController?.fetchCityInPlan(planName: UserDefaults.standard.string(forKey: "passedPlan")!, targetName: passedCityName!)
            if (passedCity==nil){
                print("error when trying to retrieve city.")
                return
            }
            
            //check if the sights have duplicate. Don't add to the city if there's duplicate
            let sights=passedCity!.sights?.allObjects as! [Sights]
            var duplicate=false
            for place in sightList{
                duplicate=false
                for sight in sights{
                    if (place==sight.name){
                        duplicate=true
                    }
                }
                
                if (!duplicate){
                    let newSight = databaseController?.addSights(name: place)
                    databaseController?.addSightsToCity(sight: newSight!, city: passedCity!)
                }
                let temp=passedCity!.sights?.allObjects as! [Sights]
                for i in temp{print(i.name!)}
            }
        }else{
        UserDefaults.standard.set(sightList, forKey: "sightList")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //this func would handle when the add button was tapped and add the sight into the sightList
    @IBAction func tapped(_ sender: Any) {
        let sightName=name.text
        if (sightName==""){
            return
        }
        if (selected==nil || sightName != selected){
            sightList.append(sightName!)
        selected=sightName
        }
        print(sightList)
    }
}
//this function would customize the UIView in this view controller and was originally developed by an online tutorial
    extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        
        guard let placeMarker = marker as? PlaceMarker else {
            return nil
        }
        guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else {
            return nil
        }
        infoView.nameLabel.text = placeMarker.place.name
        name.text=placeMarker.place.name
        address.text=placeMarker.place.address
        if let photo = placeMarker.place.photo {
            infoView.placePhoto.image = photo
        } else {
            infoView.placePhoto.image = UIImage(named: "generic")
        }
    
        return infoView
    }
}

