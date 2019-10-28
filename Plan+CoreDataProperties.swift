//
//  Plan+CoreDataProperties.swift
//  Start Traveling
//
//  Created by Xinbei Li on 4/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//
//

import Foundation
import CoreData


extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var startDate: NSDate?
    @NSManaged public var tittle: String?
    @NSManaged public var duration: String?
    @NSManaged public var author: String?
    @NSManaged public var cities: NSSet?

}

// MARK: Generated accessors for cities
extension Plan {

    @objc(addCitiesObject:)
    @NSManaged public func addToCities(_ value: Cities)

    @objc(removeCitiesObject:)
    @NSManaged public func removeFromCities(_ value: Cities)

    @objc(addCities:)
    @NSManaged public func addToCities(_ values: NSSet)

    @objc(removeCities:)
    @NSManaged public func removeFromCities(_ values: NSSet)

}
