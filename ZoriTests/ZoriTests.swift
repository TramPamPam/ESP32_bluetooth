//
//  ZoriTests.swift
//  ZoriTests
//
//  Created by Oleksandr Bezpalchuk on 4/10/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import XCTest
@testable import Zori

class ZoriTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAnglesFromDegreeMinuteSecond() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

//        auto a = astrocoords::Angle::fromDegrees(0, 0, 10);
//        EXPECT_FLOAT_EQ(10./3600., a.d());
        var a = Angle(degrees: 0, minutes: 0, seconds: 10)
        XCTAssertEqual(a.degrees, 10.0/3600.0)

//        a = astrocoords::Angle::fromDegrees(0, 10, 0);
//        EXPECT_FLOAT_EQ(10./60.,a.d());
        a = Angle(degrees: 0, minutes: 10, seconds: 0)
        XCTAssertEqual(a.degrees, 10.0/60.0)
        
//        a = astrocoords::Angle::fromDegrees(135, 0, 0);
//        EXPECT_FLOAT_EQ(135., a.d());
        a = Angle(degrees: 135, minutes: 0, seconds: 0)
        XCTAssertEqual(a.degrees, 135)

//        a = astrocoords::Angle::fromDegrees(135, 5, 15);
//        EXPECT_FLOAT_EQ(2.35772165, a.r());
        a = Angle(degrees: 135, minutes: 5, seconds: 15)
        XCTAssertEqual(a.radians, 2.35772165, accuracy: 0.00000001, "expected better from you")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
