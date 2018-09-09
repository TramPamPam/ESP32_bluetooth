//
//  Constellation+CoreDataClass.swift
//  Zori
//
//  Created by Oleksandr on 9/9/18.
//  Copyright © 2018 ekreative. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Constellation)
public class Constellation: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name = "Name"
        case name_r = "Name_r"
        case abbreviation = "Abbreviation"
        case img
        case stars
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let context = decoder.userInfo[CodingUserInfoKey.context!] as! NSManagedObjectContext
        self.init(entity: NSEntityDescription.entity(forEntityName: "Constellation", in: context)!, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let nid = try container.decodeIfPresent(Int.self, forKey: .id) else { throw CustomError.noId }
        self.id = "\(nid)"
        
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.name_r = try container.decodeIfPresent(String.self, forKey: .name_r)
        self.img = try container.decodeIfPresent(String.self, forKey: .img)
        
        if let stars = try container.decodeIfPresent([Star].self, forKey: .stars) {
            self.stars = NSSet(array: stars)
        }
        
    }
    
    static func fetchAll(from context: NSManagedObjectContext = CoreDataStackImplementation.shared.context, predicate: NSPredicate? = nil) -> [Constellation] {
        let request = NSFetchRequest<Constellation>(entityName: "Constellation")
        request.predicate = predicate
        do {
            return try context.fetch(request)
        } catch {
            debugPrint("Verse fetch error: \(error)")
            return []
        }
    }
}
