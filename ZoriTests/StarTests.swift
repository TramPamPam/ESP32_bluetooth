//
//  StarTests.swift
//  ZoriTests
//
//  Created by Oleksandr on 9/9/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import XCTest
import Moya
import PromiseKit

@testable import Zori

class StarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStarsList() {
        let coreDataStack = CoreDataStackMock()
        coreDataStack.clearDataBase()
        
        let provider = StarServiceImplementation(
            api: MoyaProvider<ZoriAPI>(stubClosure: MoyaProvider.immediatelyStub),
            coreDataStack: coreDataStack)
        
        let listExpectation = expectation(description: "provider expectation")
        provider.getList().done { (list) -> Void in
            XCTAssert(list.count == 23, "Not all loaded. Only \(list.count)/25")
            
            guard let star = Star.fetchAll(from: coreDataStack.context, predicate: NSPredicate(format: "id = %@", "424")).first else {
                let listIDs = list.compactMap { return $0.id }
                XCTFail("no 424 star in \(listIDs)")
                return
            }
            
            XCTAssertEqual(star.id, "424")
            XCTAssertEqual(star.hr, 424)
            XCTAssertEqual(star.name, "1Alp UMi")
            XCTAssertEqual(star.constellationID, 1)
            XCTAssertEqual(star.constellation, "UMi")
            XCTAssertEqual(star.constellation_r, "Малая медведица")
            XCTAssertEqual(star.name_r, "Полярная звезда")
            XCTAssertEqual(star.description_r, "Поля́рная звезда́ (Альфа Малой Медведицы (α UMi), также — Киносура[источник не указан 157 дней]) — звезда +2,0m звёздной величины в созвездии Малой Медведицы, расположенная вблизи Северного полюса мира. Это сверхгигант спектрального класса F7Ib. Расстояние до Земли — 447 ± 1.6 световых лет (137.14 парсек)[1][2].")
            
            XCTAssertEqual(star.hours, 2)
            XCTAssertEqual(star.minutes, 31)
            
            XCTAssertTrue(star.seconds.distance(to: 48.70000000000000284217094304040074348449707031250) < 0.700000000000002)
            
            XCTAssertEqual(star.sign, "+")
            
            XCTAssertEqual(star.deg, 89)
            XCTAssertEqual(star.min, 15)
            XCTAssertEqual(star.sec, 11)
            
            XCTAssertTrue(star.vmag.distance(to: 2.020000000000000017763568394002504646778106689453125) < 0.02000000000000002, "\(star.vmag)")
            XCTAssertTrue(star.gLON.distance(to: 123.280000000000001136868377216160297393798828125) < 0.280000000000001)
            XCTAssertTrue(star.gLAT.distance(to: 26.46000000000000085265128291212022304534912109375) < 0.4600000000000008)
            
            listExpectation.fulfill()
        }.catch { (error) in
            XCTFail("\(error)")
        }
        
        waitForExpectations(timeout: 3.0) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
}
