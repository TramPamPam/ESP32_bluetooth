//
//  Angle.swift
//  Zori
//
//  Created by Oleksandr on 9/9/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import Foundation
class Angle {
    var radians: Double
    var degrees: Double {
        return (radians * 180)/Double.pi
    }
    
    init(radians: Double) {
        self.radians = radians
        self.normalizeAngle()
    }
    
    init(degrees: Double) {
        self.radians = degrees*Double.pi/180
        self.normalizeAngle()
    }
    
    init(degrees: Double, minutes: Double = 0.0, seconds: Double = 0.0) {
        let fr = minutes/60.0 + seconds/3600.0
        let normDegree = degrees + (degrees >= 0 ? fr : -fr)
        self.radians = Angle.init(degrees: normDegree).radians
        //        self.normalizeAngle()
    }
    
    init(hours: Double, minutes: Double = 0, seconds: Double = 0) {
        self.radians = Angle(degrees: hours*15, minutes: minutes*15, seconds: seconds*15).radians
        self.normalizeAngle()
    }
    
    func normalizeAngle() {
        let twopi = 2 * Double.pi
        while(radians<0) {
            radians += twopi
        }
        while (radians >= twopi) {
            radians -= twopi
        }
    }
}
