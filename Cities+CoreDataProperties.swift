//
//  Cities+CoreDataProperties.swift
//  Start Traveling
//
//  Created by Xinbei Li on 4/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//
//

import Foundation
import CoreData


extension Cities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cities> {
        return NSFetchRequest<Cities>(entityName: "Cities")
    }

    @NSManaged public var name: String?
    @NSManaged public var plans: NSSet?
    @NSManaged public var sights: NSSet?

}

// MARK: Generated accessors for plans
extension Cities {

    @objc(addPlansObject:)
    @NSManaged public func addToPlans(_ value: Plan)

    @objc(removePlansObject:)
    @NSManaged public func removeFromPlans(_ value: Plan)

    @objc(addPlans:)
    @NSManaged public func addToPlans(_ values: NSSet)

    @objc(removePlans:)
    @NSManaged public func removeFromPlans(_ values: NSSet)

}

// MARK: Generated accessors for sights
extension Cities {

    @objc(addSightsObject:)
    @NSManaged public func addToSights(_ value: Sights)

    @objc(removeSightsObject:)
    @NSManaged public func removeFromSights(_ value: Sights)

    @objc(addSights:)
    @NSManaged public func addToSights(_ values: NSSet)

    @objc(removeSights:)
    @NSManaged public func removeFromSights(_ values: NSSet)

}
