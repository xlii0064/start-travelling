//
//  CoreDataController.swift
//  Start Traveling
//
//  Created by Xinbei Li on 16/4/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//


//The persistantContainer, saveContext(), fetchAllTask() and controllerDidChangeContent() was orignally created by the lab sheet of week4
import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol,NSFetchedResultsControllerDelegate{
    let DEFAULT_PLAN_NAME="default plan"
    let DEFAULT_CITY_NAME="default city"
    var persistantContainer: NSPersistentContainer
    var listeners = MulticastDelegate<DatabaseListener>()
    var allPlansFetchedController:NSFetchedResultsController<Plan>?
    var allCitiesFetchedController:NSFetchedResultsController<Cities>?
    var allSightsFetchedController:NSFetchedResultsController<Sights>?
    var planCitiesFetchedController:NSFetchedResultsController<Cities>?
    var citySightsFetchedController:NSFetchedResultsController<Sights>?
    
    //constructor to load the data
    override init() {
        persistantContainer=NSPersistentContainer(name:"Start_Traveling")
        persistantContainer.loadPersistentStores { (des, error) in
            if let error = error{
                fatalError("Failed in loading data\(error)")
            }
        }
        super.init()
        
    }
    
    //func to save the data when something changed
    func saveContext(){
        if persistantContainer.viewContext.hasChanges{
            do{
                try persistantContainer.viewContext.save()
                print("Data did saved")
            }catch{
                fatalError("Failed in loading Data")
            }
        }
    }
    
    //func to add a new plan in the database and return the newly created plan
    func addPlan(tittle: String, author:String, start:Date) ->Plan{
        
        let plan=NSEntityDescription.insertNewObject(forEntityName: "Plan", into: persistantContainer.viewContext) as! Plan
        plan.tittle=tittle
        plan.author=author
        plan.startDate=start as NSDate
        saveContext()
        return plan
    }
    //func to add a new city in the database and return the newly created city
    func addCities(name:String)-> Cities{
        let city=NSEntityDescription.insertNewObject(forEntityName:"Cities",into:persistantContainer.viewContext) as! Cities
        city.name=name
        saveContext()
        return city
    }
    //func to add a new sight in the database and return the newly created sight
    func addSights(name:String)->Sights{
        let sight=NSEntityDescription.insertNewObject(forEntityName:"Sights",into:persistantContainer.viewContext) as! Sights
        sight.name=name
        saveContext()
        return sight
    }
    //func to add a city to the plan
    func addCitiesToPlan(city: Cities, plan: Plan)-> Bool{
        guard plan.cities?.contains(city)==false else {
            return false
        }
        plan.addToCities(city)
        saveContext()
        return true
    }
    //func to add a sight to the city
    func addSightsToCity(sight: Sights, city:Cities)->Bool{
        guard city.sights?.contains(sight)==false else {
            return false
        }
        city.addToSights(sight)
        saveContext()
        return true
    }
    
    //func to delete a sight in the database
    func deleteSights(sight :Sights){
        persistantContainer.viewContext.delete(sight)
        saveContext()
    }
    //func to delete a city in the database
    func deleteCities(city: Cities){
        persistantContainer.viewContext.delete(city)
        saveContext()
    }
    //func to delete a plan in the database
    func deletePlan(plan: Plan){
        persistantContainer.viewContext.delete(plan)
        saveContext()
    }

    //func to remove a sight from a city
    func removeSightsFromCity(sight:Sights,city:Cities){
        city.removeFromSights(sight)
        saveContext()
    }
    //func to remove a city from a plan
    func removeCityFromPlan(city: Cities,plan:Plan){
        plan.removeFromCities(city)
        saveContext()
    }
    
    //func to add listener in the database
    func addListener(listener: DatabaseListener){
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.plans || listener.listenerType == ListenerType.all{
            listener.onPlanChange(change: .update, cities: fetchPlanCities())
        }
        if listener.listenerType == ListenerType.cities || listener.listenerType == ListenerType.all{
            listener.onCityChange(change: .update, sights: fetchCitySights())
        }
        if listener.listenerType == ListenerType.sights || listener.listenerType == ListenerType.all{
            listener.onSightsListChange(change: .update, sights: fetchAllSights())
        }
    }
    //func to remove listener
    func removerListener(listener: DatabaseListener){
        listeners.removeDelegate(listener)
    }
    
    //func to fetch all cities in a plan
    func fetchPlanCities()->[Cities]{
        if planCitiesFetchedController == nil {
            let fetchRequest: NSFetchRequest<Cities> = Cities.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            let predicate = NSPredicate(format: "ANY plans.tittle == %@",
                                        DEFAULT_PLAN_NAME)
            fetchRequest.predicate = predicate
            planCitiesFetchedController = NSFetchedResultsController<Cities>(fetchRequest: fetchRequest,managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            planCitiesFetchedController?.delegate = self
            do {
                try planCitiesFetchedController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)") }
        }
        var cities = [Cities]()
        if planCitiesFetchedController?.fetchedObjects != nil {
            cities = (planCitiesFetchedController?.fetchedObjects)! }
        return cities
        
    }
    func fetchCityInPlan(planName:String,targetName:String)->Cities?{
        if planCitiesFetchedController == nil {
            let fetchRequest: NSFetchRequest<Cities> = Cities.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            let predicate = NSPredicate(format: "ANY plans.tittle == %@",
                                        planName)
            fetchRequest.predicate = predicate
            planCitiesFetchedController = NSFetchedResultsController<Cities>(fetchRequest: fetchRequest,managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            planCitiesFetchedController?.delegate = self
            do {
                try planCitiesFetchedController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)") }
        }
        var cities = [Cities]()
        if planCitiesFetchedController?.fetchedObjects != nil {
            cities = (planCitiesFetchedController?.fetchedObjects)! }
        for i in cities{
            if (i.name == targetName){
                return i
            }
        }
        return nil
    }
    //func to fetch all sights in a city
    func fetchCitySights()->[Sights]{
        if citySightsFetchedController == nil {
            let fetchRequest: NSFetchRequest<Sights> = Sights.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            let predicate = NSPredicate(format: "ANY city.name == %@",
                                        DEFAULT_CITY_NAME)
            fetchRequest.predicate = predicate
            citySightsFetchedController = NSFetchedResultsController<Sights>(fetchRequest: fetchRequest,managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            citySightsFetchedController?.delegate = self
            do {
                try citySightsFetchedController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)") }
        }
        var sights = [Sights]()
        if citySightsFetchedController?.fetchedObjects != nil {
            sights = (citySightsFetchedController?.fetchedObjects)! }
        return sights
        
    }
    // this func would fetch all the cities in the core data and return a list that contains all the cities
    func fetchAllCities() -> [Cities]{
        if allCitiesFetchedController == nil{
            let request: NSFetchRequest<Cities> = Cities.fetchRequest()
            let nameSorted=NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors=[nameSorted]
            allCitiesFetchedController=NSFetchedResultsController<Cities>(fetchRequest: request, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            do{
                try allCitiesFetchedController?.performFetch()
            }catch{
                print("fetch failed")
            }
        }
        var cities=[Cities]()
        if allCitiesFetchedController?.fetchedObjects != nil{
            cities = (allCitiesFetchedController?.fetchedObjects)!
        }
        return cities
    }
    //func to fetch all sights
    func fetchAllSights() -> [Sights]{
        if allSightsFetchedController == nil{
            let request: NSFetchRequest<Sights> = Sights.fetchRequest()
            let nameSorted=NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors=[nameSorted]
            allSightsFetchedController=NSFetchedResultsController<Sights>(fetchRequest: request, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            do{
                try allSightsFetchedController?.performFetch()
            }catch{
                print("fetch failed")
            }
        }
        var sights=[Sights]()
        if allSightsFetchedController?.fetchedObjects != nil{
            sights = (allSightsFetchedController?.fetchedObjects)!
        }
        return sights
    }
    
    
    
    
    
    
 func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allSightsFetchedController { listeners.invoke
            { (listener) in
            if listener.listenerType == ListenerType.sights || listener.listenerType == ListenerType.all {
                listener.onSightsListChange(change: .update, sights: fetchAllSights())}
            }
            
        }
        else if controller == citySightsFetchedController { listeners.invoke
            { (listener) in
            if listener.listenerType == ListenerType.cities || listener.listenerType == ListenerType.all {
                listener.onCityChange(change: .update, sights: fetchCitySights())}
            }
        }
    if controller == planCitiesFetchedController { listeners.invoke
        { (listener) in
            if listener.listenerType == ListenerType.plans || listener.listenerType == ListenerType.all {
                listener.onPlanChange(change: .update, cities: fetchPlanCities())}
        }
    }
}

    lazy var defaultPlan: Plan = {
        var plans = [Plan]()
        let request: NSFetchRequest<Plan> = Plan.fetchRequest();
        let predicate = NSPredicate(format: "name = %@", DEFAULT_PLAN_NAME)
        request.predicate = predicate
        do {
            try plans = persistantContainer.viewContext.fetch(Plan.fetchRequest())
                as! [Plan]
        } catch {
            print("Fetch Request failed: \(error)") }
        if plans.count == 0 {
            return addPlan(tittle: "Sample Plan", author: "Me", start: Date()) }
        else {
            return plans.first! }
    }()
    

    
    
    
    
    
}
