//
//  Converter.swift
//  Zori
//
//  Created by Oleksandr on 9/5/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import Foundation

class Converter {
    var latitude: Angle?
    var longitude: Angle?
    
    var daysFromJ2000 = 0.0
    var UTCtime = 0.0

    func setLocation(latitude: Angle, longitude: Angle) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func setUTCDateAndTime(year: Int, month: Int, day: Int, hour: Int, minute: Int, seconds: Int) {
        var datecomps = DateComponents(calendar: Calendar.current,
                                       timeZone: TimeZone(abbreviation: "UTC")!,
                                       year: 2000,
                                       month: 1,
                                       day: 1,
                                       hour: 12,
                                       minute: 0,
                                       second: 0)
        let date2000 = Calendar.current.date(from: datecomps)!
        datecomps = DateComponents(calendar: Calendar.current,
                                   timeZone: TimeZone(abbreviation: "UTC")!,
                                   year: year,
                                   month: month,
                                   day: day,
                                   hour: hour,
                                   minute: minute,
                                   second: seconds)
        
        let datePassed = Calendar.current.date(from: datecomps)!

        let diff = datePassed.timeIntervalSince(date2000)
        daysFromJ2000 = diff / 86400.0
        UTCtime = Double(hour) + Double(minute)/60.0 + Double(seconds)/3600.0
    }
    
    
    /// Returns (azimuth, altitude)
    func equatorialToHorizontal(rightAngle: Angle, declination: Angle) -> (Angle, Angle) {
        let localTime = Angle(degrees: 100.46 + 0.985647 * daysFromJ2000 + longitude!.degrees + 15*UTCtime);
        
        let hourAngle = Angle(degrees: localTime.degrees - rightAngle.degrees)
        let altitude = Angle(radians: asin(sin(declination.radians)*sin(latitude!.radians) + cos(declination.radians)*cos(latitude!.radians)*cos(hourAngle.radians)))
        
        var A = acos( (sin(declination.radians) - sin(altitude.radians)*sin(latitude!.radians))/(cos(altitude.radians)*cos(latitude!.radians)))
        if(sin(hourAngle.radians)>=0) {
            A = 2 * Double.pi - A
        }
        
        let azimuth = Angle(radians: A)
        return (azimuth, altitude)
    }
    
    ///returns: (azimuth, altitude)
    func point(to star: Star) -> (Angle, Angle) {
        //beta-orion in Cherkasy, UA at 22:00UTC, 17th February 2018

        let lat = Angle(degrees: 49, minutes: 26, seconds: 40)
        let lon = Angle(degrees: 32, minutes: 3, seconds: 35)
        
        setLocation(latitude: lat, longitude: lon)
        
        //beta-orion
        let rightAngle = Angle(hours: star.hours, minutes: star.minutes, seconds: star.seconds)
        let declination = Angle(degrees: star.deg, minutes: star.min, seconds: star.sec)
        return equatorialToHorizontal(rightAngle: rightAngle, declination: declination)
    }
}

///HOW TO USE!
/*
 "id": 424,
 "HR": 424,
 "Name": "1Alp UMi",
 "Constellation": "UMi",
 "Constellation_r": "Малая медведица",
 "Name_r": "Полярная звезда",
 "Description_r": "",
 "Hours": 2,
 "Minutes": 31,
 "Seconds": 48.7000000000000028421709430404007434844970703125,
 "Sign": "+",
 "Deg": 89,
 "Min": 15,
 "Sec": 11,
 "Vmag": 2.020000000000000017763568394002504646778106689453125,

 */



