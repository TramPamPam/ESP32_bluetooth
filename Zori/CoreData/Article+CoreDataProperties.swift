//
//  Article+CoreDataProperties.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var nid: String?
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var description_rss: String?
    @NSManaged public var url_json_full: String?
    @NSManaged public var img: Image?

}
