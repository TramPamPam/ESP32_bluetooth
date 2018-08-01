//
//  CustomMoyaProvider.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import UIKit
import Moya
import PromiseKit

extension MoyaProvider {
    func request(_ target: Target) -> Promise<Response> {
        return Promise<Moya.Response> { seal in
            self.request(target, callbackQueue: .main, progress: nil, completion: { result in
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        seal.fulfill(response)
                    } catch {
                        if response.statusCode == 401 && target.allowedToFail != true {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
                        }
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            })
        }
    }
}

extension Promise where T: Moya.Response {
    func decode<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder() ) -> Promise<D> {
        return map { (response) in
            try response.map(D.self, atKeyPath: keyPath, using: decoder)
        }
    }
}
