//
//  DatabaseProtocol.swift
//  Start Traveling
//
//  Created by Xinbei Li on 16/4/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

// the enum Foundation was referencing from the week4 lab
import Foundation
enum DatabaseChange{
    case add
    case delete
    case update
}
enum ListenerType {
    case cities
    case plans
    case sights
    case all
}
protocol DatabaseListener: AnyObject{
    var listenerType: ListenerType {get set}
    func onPlanChange(change: DatabaseChange, cities: [Cities])
    func onCityChange(change: DatabaseChange,sights:[Sights])
    func onSightsListChange(change:DatabaseChange, sights:[Sights])
    
}

// This protocol contains 12 functions that can manipulate the data of the tasks inside the database
protocol DatabaseProtocol:AnyObject {
    func addPlan(tittle: String, author:String, start:Date) ->Plan
    func addCities(name:String)-> Cities
    func addSights(name:String)->Sights
    
    func addCitiesToPlan(city: Cities, plan: Plan)-> Bool
    func addSightsToCity(sight: Sights, city:Cities)->Bool
    
    func deleteSights(sight :Sights)
    func deleteCities(city: Cities)
    func deletePlan(plan: Plan)
    
    func removeSightsFromCity(sight:Sights,city:Cities)
    func removeCityFromPlan(city: Cities,plan:Plan)
    
    func addListener(listener: DatabaseListener)
    func removerListener(listener: DatabaseListener)
    
    func fetchCityInPlan(planName:String,targetName:String)->Cities?
}
