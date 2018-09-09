//
//  StarService.swift
//  Zori
//
//  Created by Oleksandr on 9/9/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import Moya
import PromiseKit

protocol StarService: class {
    var coreDataStack: CoreDataStack { get set}
    
    func getList() -> Promise<[Star]>
    
}

final class StarServiceImplementation: StarService {
    var coreDataStack: CoreDataStack
    var api: MoyaProvider<ZoriAPI>
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = self.coreDataStack.context
        return decoder
    }()
    
    //MARK: -
    init(api: MoyaProvider<ZoriAPI>, coreDataStack: CoreDataStack = CoreDataStackImplementation.shared) {
        self.coreDataStack = coreDataStack
        self.api = api
    }
    
    func getList() -> Promise<[Star]> {
        let target: ZoriAPI = .getList
        return api
            .request(target)
            .decode([Star].self, atKeyPath: nil, using: decoder)
            .map { _ in
                self.coreDataStack.saveContext()
                return Star.fetchAll(from: self.coreDataStack.context)
        }
    }

}
