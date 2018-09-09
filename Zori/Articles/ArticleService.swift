//
//  ArticleService.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import Moya
import PromiseKit

protocol ArticleService: class {
    var coreDataStack: CoreDataStack { get set}
    
    func getList() -> Promise<[Article]>
    func getFull(_ article: Article) -> Promise<Article>

}

final class ArticleServiceImplementation: ArticleService {
    var coreDataStack: CoreDataStack
    var api: MoyaProvider<ArticleAPI>
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = self.coreDataStack.context
        return decoder
    }()
    
    //MARK: -
    init(api: MoyaProvider<ArticleAPI>, coreDataStack: CoreDataStack = CoreDataStackImplementation.shared) {
        self.coreDataStack = coreDataStack
        self.api = api
    }
    
    func getList() -> Promise<[Article]> {
        let target: ArticleAPI = .getList
        return api
            .request(target)
            .decode([Article].self, atKeyPath: target.keyPath, using: decoder)
            .map { _ in
                self.coreDataStack.saveContext()
                return Article.fetchAll(from: self.coreDataStack.context)
        }
    }
    
    func getFull(_ article: Article) -> Promise<Article> {
        guard let url = article.url_json_full, !url.isEmpty else {
            return Promise<Article>(error: CustomError.missingField(field: "url_json_full"))
        }
        let target: ArticleAPI = .getFull(article: article)
        return api
            .request(target)
            .decode(Article.self, atKeyPath: target.keyPath, using: decoder)
            .map { _ in
                self.coreDataStack.saveContext()
                return article
        }
    }
    
    
}
