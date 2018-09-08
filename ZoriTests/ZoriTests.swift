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
        var a = Angle(degrees: 0, minutes: 0, seconds: 10)
        XCTAssertEqual(a.degrees, 10.0/3600.0)

        a = Angle(degrees: 0, minutes: 10, seconds: 0)
        XCTAssertEqual(a.degrees, 10.0/60.0)

        a = Angle(degrees: 135, minutes: 0, seconds: 0)
        XCTAssertEqual(a.degrees, 135)

        a = Angle(degrees: 135, minutes: 5, seconds: 15)
        XCTAssertEqual(a.radians, 2.35772165, accuracy: 0.00000001, "expected better from you")

        a = Angle(hours: 7, minutes: 5, seconds: 15)
        XCTAssertEqual(a.radians, 1.85550316, accuracy: 0.00000001, "expected better from you")
    }
    
    func testNormalize() {
        var a = Angle(degrees: -25)
        a.normalizeAngle()
        XCTAssertEqual(360-25, a.degrees)
        
        a = Angle(degrees: 3610)
        a.normalizeAngle()

        XCTAssertEqual(10, Int(a.degrees.rounded()))
    }
    
    func testEquatorialToHorizontalExample() {
    
        let cconv = Converter()
        //Birmingham
        cconv.setLocation(latitude: Angle(degrees: 52, minutes: 30, seconds: 0),
                          longitude: Angle(degrees: -1, minutes: 55, seconds: 0))
        cconv.setUTCDateAndTime(year: 1998, month: 8, day: 10, hour: 23, minute: 10, seconds: 0)
        
        let res = cconv.equatorialToHorizontal(rightAngle: Angle(hours: 16, minutes: 41.7, seconds: 0),
                                     declination: Angle(degrees: 36, minutes: 28, seconds: 0))
        let az = res.0
        let alt = res.1
        
        XCTAssertEqual(alt.degrees, 49.2, accuracy: 0.1)
        XCTAssertEqual(az.degrees, 269.146321700171, accuracy: 0.0000001)
       
    }
    
    func testEquatorialToHorizontalPolar() {
        let cconv = Converter()
        //Cherkasy, UA
        cconv.setLocation(latitude: Angle(degrees: 49, minutes: 26, seconds: 40),
                          longitude: Angle(degrees: 32, minutes: 3, seconds: 35))
        //18:57UTC, 19th February 2018
        cconv.setUTCDateAndTime(year: 2018, month: 2, day: 19, hour: 18, minute: 57, seconds: 0)
        
        //Polaris (alpha Ursa minor)
        var res = cconv.equatorialToHorizontal(rightAngle: Angle(hours: 2, minutes: 32, seconds: 0),
                                               declination: Angle(degrees: 89, minutes: 16, seconds: 0))
        var az = res.0
        var alt = res.1

        XCTAssertEqual(alt.degrees, 49.7146368770826, accuracy: 0.0000001)
        XCTAssertEqual(az.degrees, 358.948549281305, accuracy: 0.0000001)

        //15:50UTC, 19th February 2018
        cconv.setUTCDateAndTime(year: 2018, month: 2, day: 19, hour: 15, minute: 50, seconds: 0)

        res = cconv.equatorialToHorizontal(rightAngle: Angle(hours: 2, minutes: 32, seconds: 0),
                                           declination: Angle(degrees: 89, minutes: 16, seconds: 0))
        az = res.0
        alt = res.1
        
        XCTAssertEqual(alt.degrees, 50.1278736546139, accuracy: 0.0000001)
        XCTAssertEqual(az.degrees, 359.588150276558, accuracy: 0.0000001)

    }

    func testEquatorialToHorizontalBetaOrion() {
        let cconv = Converter()
        //Cherkasy, UA
        cconv.setLocation(latitude: Angle(degrees: 49, minutes: 26, seconds: 40),
                          longitude: Angle(degrees: 32, minutes: 3, seconds: 35))
        //15:50UTC, 19th February 2018
        cconv.setUTCDateAndTime(year: 2018, month: 2, day: 19, hour: 15, minute: 50, seconds: 0)

        //beta-orion
        let res = cconv.equatorialToHorizontal(rightAngle: Angle(hours: 5, minutes: 14, seconds: 32.27210),
                                               declination: Angle(degrees: -8, minutes:  12, seconds: 5.8981))
        let az = res.0
        let alt = res.1
        
        XCTAssertEqual(alt.degrees, 29.8754864915581, accuracy: 0.0000001)
        XCTAssertEqual(az.degrees, 157.565895398311, accuracy: 0.0000001)

    }
    
    func testNotFull() {
        let a = Angle.init(degrees: -1, minutes: 55, seconds: 0)
        XCTAssertEqual(a.degrees, 360-1.9166667, accuracy: 0.0000001, "actual: \(a.degrees)")
    }
    
    
}
