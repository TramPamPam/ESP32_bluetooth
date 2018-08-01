//
//  ArticleTests.swift
//  ZoriTests
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import XCTest
import Moya
import PromiseKit

@testable import Zori

class ArticleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testArticlesList() {
        let coreDataStack = CoreDataStackMock()
        coreDataStack.clearDataBase()
        
        let provider = ArticleServiceImplementation(
            api: MoyaProvider<ArticleAPI>(stubClosure: MoyaProvider.immediatelyStub),
            coreDataStack: coreDataStack)
        
        let listExpectation = expectation(description: "provider expectation")
        provider.getList().done { (list) -> Void in
            XCTAssert(list.count == 5, "Not all loaded. Only \(list.count)/5")
            let article = list.first!
            
            XCTAssertNotNil(article.nid)
            XCTAssertNotNil(article.title)
            XCTAssertNotNil(article.body)
            XCTAssertNotNil(article.description_rss)
            XCTAssertNotNil(article.url_json_full)
            
            guard let image = article.img else { throw CustomError.missingField(field: "img") }
            XCTAssertNotNil(image.src)
            
            listExpectation.fulfill()
        }.catch { (error) in
            XCTFail(error.localizedDescription)
        }
        
        waitForExpectations(timeout: 3.0) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
        
    }
    
}
