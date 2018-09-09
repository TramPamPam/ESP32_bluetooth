//
//  Star+CoreDataProperties.swift
//  Zori
//
//  Created by Oleksandr on 9/9/18.
//  Copyright © 2018 ekreative. All rights reserved.
//
//

import Foundation
import CoreData


extension Star {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Star> {
        return NSFetchRequest<Star>(entityName: "Star")
    }

    @NSManaged public var id: String?
    @NSManaged public var hr: Int32
    @NSManaged public var name: String?
    @NSManaged public var constellationID: Int32
    @NSManaged public var constellation: String?
    @NSManaged public var constellation_r: String?
    @NSManaged public var name_r: String?
    @NSManaged public var description_r: String?
    @NSManaged public var hours: Double
    @NSManaged public var minutes: Double
    @NSManaged public var seconds: Double
    @NSManaged public var sign: String?
    @NSManaged public var deg: Double
    @NSManaged public var min: Double
    @NSManaged public var sec: Double
    @NSManaged public var vmag: Double
    @NSManaged public var gLON: Double
    @NSManaged public var gLAT: Double

}
