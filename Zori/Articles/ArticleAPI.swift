//
//  ArticleAPI.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import Moya

enum ArticleAPI {
    case getList
    case getFull(article: Article)
}

extension ArticleAPI: TargetType {
    var path: String {
        switch self {
        case .getList:
            return "news.json"
        case .getFull(let article):
            return article.url_json_full!
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return NSDataAsset(name: "articles")!.data
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var keyPath: String? {
        switch self {
        case .getList:
            return "nodes.node"
        default:
            return nil
        }
    }
}

