//
//  Image+CoreDataProperties.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var src: String?
    @NSManaged public var alt: String?
    @NSManaged public var articles: NSSet?

}

// MARK: Generated accessors for articles
extension Image {

    @objc(addArticlesObject:)
    @NSManaged public func addToArticles(_ value: Article)

    @objc(removeArticlesObject:)
    @NSManaged public func removeFromArticles(_ value: Article)

    @objc(addArticles:)
    @NSManaged public func addToArticles(_ values: NSSet)

    @objc(removeArticles:)
    @NSManaged public func removeFromArticles(_ values: NSSet)

}
