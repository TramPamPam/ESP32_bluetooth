//
//  Article+CoreDataClass.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Article)
public class Article: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case nid
        case title
        case body
        case description_rss
        case url_json_full
        case img
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let context = decoder.userInfo[CodingUserInfoKey.context!] as! NSManagedObjectContext
        self.init(entity: NSEntityDescription.entity(forEntityName: "Article", in: context)!, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let nid = try container.decodeIfPresent(String.self, forKey: .nid) else { throw CustomError.noId }
        self.nid = nid
        
        title = try container.decodeIfPresent(String.self, forKey: .title)
        body = try container.decodeIfPresent(String.self, forKey: .body)
        description_rss = try container.decodeIfPresent(String.self, forKey: .description_rss)
        url_json_full = try container.decodeIfPresent(String.self, forKey: .url_json_full)
        
        img = try container.decodeIfPresent(String.self, forKey: .img)
        
    }
    
    static func fetchAll(from context: NSManagedObjectContext = CoreDataStackImplementation.shared.context, predicate: NSPredicate? = nil) -> [Article] {
        let request = NSFetchRequest<Article>(entityName: "Article")
        request.predicate = predicate
        do {
            return try context.fetch(request)
        } catch {
            debugPrint("Verse fetch error: \(error)")
            return []
        }
    }
}
