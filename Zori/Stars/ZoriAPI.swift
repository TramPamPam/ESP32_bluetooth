//
//  ZoriAPI.swift
//  Zori
//
//  Created by Oleksandr on 9/5/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import Moya

enum ZoriAPI {
    case getList
}

extension ZoriAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://star.3339333.xyz")!
    }
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return NSDataAsset(name: "stars")!.data
    }
    
    var task: Task {
        return .requestParameters(parameters: ["catalog" : 1], encoding: URLEncoding.default)
    }
    
    
}
