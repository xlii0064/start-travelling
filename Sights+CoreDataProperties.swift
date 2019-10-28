//
//  Sights+CoreDataProperties.swift
//  Start Traveling
//
//  Created by Xinbei Li on 4/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//
//

import Foundation
import CoreData


extension Sights {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sights> {
        return NSFetchRequest<Sights>(entityName: "Sights")
    }

    @NSManaged public var name: String?
    @NSManaged public var cities: Cities?

}
