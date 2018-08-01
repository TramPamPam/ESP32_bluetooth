//
//  CustomError.swift
//  Zori
//
//  Created by Oleksandr Bezpalchuk on 2/20/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case wrongParameters(parameters: [String: Any])
    case missingField(field: String)
    case wrongPath(path: String)
    case cannotFetch(id: String)
    case cannotAccessDocumentsDirectory
    case noId
    case operationCanceled
}

extension CustomError {
    var localizedDescription: String {
        switch self {
        case .operationCanceled:
            return "operationCanceled"
        case .wrongParameters(let parameters):
            return "Parameters \(parameters) are wrong!"
        case .missingField(let field):
            return "Field \(field) is missing!"
        case .wrongPath(let path):
            return "Path \(path) is wrong!"
        case .cannotFetch(let id):
            return "Cannot fetch entity w/ \(id) from db!"
        case .cannotAccessDocumentsDirectory:
            return "cannot access documents directory"
        case .noId:
            return "NO ID"
        }
    }
}
