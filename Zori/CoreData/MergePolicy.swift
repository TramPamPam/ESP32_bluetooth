//
//  MergePolicy.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import UIKit
import CoreData

class MergePolicy: NSMergePolicy {
    
    class func custom() -> MergePolicy {
        return MergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    }
    
    private override init(merge ty: NSMergePolicyType) {
        super.init(merge: ty)
    }
    
    override func resolve(constraintConflicts list: [NSConstraintConflict]) throws {
        for conflict in list {
            guard let databaseObject = conflict.databaseObject else {
                try super.resolve(constraintConflicts: list)
                return
            }
            
            let allKeys = databaseObject.entity.attributesByName.keys
            
            for conflictObject in conflict.conflictingObjects {
                let changedKeys = conflictObject.changedValues().keys
                let keys = allKeys.filter { !changedKeys.contains($0) }
                for key in keys {
                    let value = databaseObject.value(forKey: key)
                    conflictObject.setValue(value, forKey: key)
                }
            }
        }
        try super.resolve(constraintConflicts: list)
    }
    
}
