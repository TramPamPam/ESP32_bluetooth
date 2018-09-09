//
//  CustomTargetType.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import Foundation
import Moya

extension TargetType {
    var baseURL: URL {
        let urlPath = "\(Bundle.main.object(forInfoDictionaryKey: "APP_SERVER")!)"
        return URL(string: urlPath)!
    }
    
    func url() -> String {
        return baseURL.appendingPathComponent(self.path).absoluteString
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var allowedToFail: Bool? {
        return nil
    }
}
