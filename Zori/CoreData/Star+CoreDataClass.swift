//
//  Star+CoreDataClass.swift
//  Zori
//
//  Created by Oleksandr on 9/9/18.
//  Copyright © 2018 ekreative. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Star)
public class Star: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case hr = "HR"
        case name = "Name"
        case name_r = "Name_r"
        case constellationID = "ConstellationID"
        case constellation = "Constellation"
        case constellation_r = "Constellation_r"
        case description_r = "Description_r"
        case sign = "Sign"
        case hours = "Hours"
        case minutes = "Minutes"
        case seconds = "Seconds"
        case deg = "Deg"
        case min = "Min"
        case sec = "Sec"
        case vmag = "Vmag"
        case gLON = "GLON"
        case gLAT = "GLAT"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let context = decoder.userInfo[CodingUserInfoKey.context!] as! NSManagedObjectContext
        self.init(entity: NSEntityDescription.entity(forEntityName: "Star", in: context)!, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let nid = try container.decodeIfPresent(Int.self, forKey: .id) else { throw CustomError.noId }
        self.id = "\(nid)"
        
        self.constellationID = try container.decodeIfPresent(Int32.self, forKey: .constellationID) ?? 0
        self.hr = try container.decodeIfPresent(Int32.self, forKey: .hr) ?? 0

        self.constellation = try container.decodeIfPresent(String.self, forKey: .constellation)
        self.constellation_r = try container.decodeIfPresent(String.self, forKey: .constellation_r)
        self.description_r = try container.decodeIfPresent(String.self, forKey: .description_r)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.name_r = try container.decodeIfPresent(String.self, forKey: .name_r)
        self.sign = try container.decodeIfPresent(String.self, forKey: .sign)
        
        self.hours = try container.decodeIfPresent(Double.self, forKey: .hours) ?? 0
        self.minutes = try container.decodeIfPresent(Double.self, forKey: .minutes) ?? 0
        self.seconds = try container.decodeIfPresent(Double.self, forKey: .seconds) ?? 0
        
        self.deg = try container.decodeIfPresent(Double.self, forKey: .deg) ?? 0
        self.min = try container.decodeIfPresent(Double.self, forKey: .min) ?? 0
        self.sec = try container.decodeIfPresent(Double.self, forKey: .sec) ?? 0

        self.vmag = try container.decodeIfPresent(Double.self, forKey: .vmag) ?? 0
        self.gLAT = try container.decodeIfPresent(Double.self, forKey: .gLAT) ?? 0
        self.gLON = try container.decodeIfPresent(Double.self, forKey: .gLON) ?? 0
    }
    
    static func fetchAll(from context: NSManagedObjectContext = CoreDataStackImplementation.shared.context, predicate: NSPredicate? = nil) -> [Star] {
        let request = NSFetchRequest<Star>(entityName: "Star")
        request.predicate = predicate
        do {
            return try context.fetch(request)
        } catch {
            debugPrint("Verse fetch error: \(error)")
            return []
        }
    }
    
}
