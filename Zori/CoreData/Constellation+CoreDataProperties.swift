//
//  Constellation+CoreDataProperties.swift
//  Zori
//
//  Created by Oleksandr on 9/9/18.
//  Copyright © 2018 ekreative. All rights reserved.
//
//

import Foundation
import CoreData


extension Constellation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Constellation> {
        return NSFetchRequest<Constellation>(entityName: "Constellation")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var name_r: String?
    @NSManaged public var img: String?
    @NSManaged public var abbreviation: String?
    @NSManaged public var stars: NSSet?

}

// MARK: Generated accessors for stars
extension Constellation {

    @objc(addStarsObject:)
    @NSManaged public func addToStars(_ value: Star)

    @objc(removeStarsObject:)
    @NSManaged public func removeFromStars(_ value: Star)

    @objc(addStars:)
    @NSManaged public func addToStars(_ values: NSSet)

    @objc(removeStars:)
    @NSManaged public func removeFromStars(_ values: NSSet)

}
