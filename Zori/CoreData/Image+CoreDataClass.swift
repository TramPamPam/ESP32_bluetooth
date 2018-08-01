//
//  Image+CoreDataClass.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Image)
public class Image: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case src
        case alt
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let context = decoder.userInfo[CodingUserInfoKey.context!] as! NSManagedObjectContext
        self.init(entity: NSEntityDescription.entity(forEntityName: "Image", in: context)!, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let src = try container.decodeIfPresent(String.self, forKey: .src) else { throw CustomError.noId }
        self.src = src
        alt = try container.decodeIfPresent(String.self, forKey: .alt)
    }
}
