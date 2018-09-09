//
//  ConstellationAPI.swift
//  Zori
//
//  Created by Oleksandr on 9/9/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import Moya

enum ConstellationAPI {
    case getList
}

extension ConstellationAPI: TargetType {
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return NSDataAsset(name: "constellations")!.data
    }
    
    var task: Task {
        return .requestParameters(parameters: ["catalog" : "constellation"], encoding: URLEncoding.default)
    }
    
    
}
