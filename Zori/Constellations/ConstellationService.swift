//
//  ConstellationService.swift
//  Zori
//
//  Created by Oleksandr on 9/9/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import Moya
import PromiseKit

protocol ConstellationService: class {
    var coreDataStack: CoreDataStack { get set}
    
    func getList() -> Promise<[Constellation]>
    
}

final class ConstellationServiceImplementation: ConstellationService {
    var coreDataStack: CoreDataStack
    var api: MoyaProvider<ConstellationAPI>
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = self.coreDataStack.context
        return decoder
    }()
    
    //MARK: -
    init(api: MoyaProvider<ConstellationAPI>, coreDataStack: CoreDataStack = CoreDataStackImplementation.shared) {
        self.coreDataStack = coreDataStack
        self.api = api
    }
    
    func getList() -> Promise<[Constellation]> {
        let target: ConstellationAPI = .getList
        return api
            .request(target)
            .decode([Constellation].self, atKeyPath: nil, using: decoder)
            .map { _ in
                self.coreDataStack.saveContext()
                return Constellation.fetchAll(from: self.coreDataStack.context)
        }
    }
    
}
