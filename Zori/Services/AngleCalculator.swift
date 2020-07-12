//
//  AngleCalculator.swift
//  Zori
//
//  Created by Oleksandr on 01.03.2020.
//  Copyright © 2020 ekreative. All rights reserved.
//
import Foundation

final class AngleCalculator {

    func altAzCalculate(ra: Double, dec: Double, lat: Double, long: Double, date: Date) -> (alt: Double, az: Double) {
        // Day offset and Local Siderial Time

        // Local Sidereal Time (https://astronomy.stackexchange.com/questions/24859/local-sidereal-time)
        /* LST=100.46+0.985647*d+long+15*UT
         WHAT THE FUCK IS UT? try to use current UT, and check with some online services
         The value of 100.46061837 degrees is the value needed to make the expression yield the correct value for GMST at 0h UT on 1 January 2000
         The value of 0.985647 degrees per day is the number of degrees the Earth rotates in one mean solar day, sans a multiple of 360
         The value of 15 degrees per hour is the number of degrees the Earth rotates with respect to the mean fictitious Sun every hour
         let LST = (100.46061837 + 0.985647 * dayOffset + Long + 15 * (date.getHours() + date.getMinutes() / 60) + 360) % 360;*/
        let LST = calculateLST(date, long)


        // Hour Angle
        let angleLST = LST * 15;
        let HA = (angleLST - ra + 360).truncatingRemainder(dividingBy: 360)

        // HA, DEC, Lat to Alt, AZ
        let x = cos(HA * (.pi / 180)) * cos(dec * (.pi / 180));
        let y = sin(HA * (.pi / 180)) * cos(dec * (.pi / 180));
        let z = sin(dec * (.pi / 180));

        let xhor = x * cos((90 - lat) * (.pi / 180)) - z * sin((90 - lat) * (.pi / 180));
        let yhor = y;
        let zhor = x * sin((90 - lat) * (.pi / 180)) + z * cos((90 - lat) * (.pi / 180));

        let az = atan2(yhor, xhor) * (180 / .pi) + 180;
        let alt = asin(zhor) * (180 / .pi);

        return (
            alt: alt,
            az: az
        )
    }

    func calculateLST(_ date: Date, _ longitude: Double) -> Double {
        // http://radixpro.com/a4a-start/sidereal-time/
        var calendarUTC = Calendar.current
        calendarUTC.timeZone = TimeZone(secondsFromGMT: 0)!

        let dateForST0 = calendarUTC.startOfDay(for: date)
        dateForST0.timestamp
        let factorT = calculateFactorT(dateForST0);

        // Step1. Calculate the mean sidereal time (ST) for Greenwich at 0:00 hours UT.
        // ST0 is ST at 0:00 hours UT at Greenwich, T is factor T (in degrees)
        var ST0 = 100.46061837
            + 36000.770053608 * factorT.T
            + (0.000387933 * factorT.T * factorT.T)
            - ((factorT.T * factorT.T * factorT.T)/38710000)

        // These are decimal degrees, you substract 6120 degrees (17 x 360) to get a result between 0 and 360 degrees: 41.69910818
        ST0.formTruncatingRemainder(dividingBy: 360)

        // Divide the result by 15 to get decimal hours: 2.7799405453, this is ST0
        ST0 /= 15;


        // Step 2: correction for actual UT
        // Add the correction for the actual UT:
        // Convert 21:17:30 to decimal hours, the result is 21.291666666667

        //Get time from midnight to date (with additional correction 1.00273790935)
        let diffDate = date.timestamp - dateForST0.timestamp
        let additionalHours: TimeInterval = (diffDate / 60 / 60 / 1000) * 1.00273790935

        // Add to ST0:
        ST0 += additionalHours;

        // Step 3, correction for geographic longitude
        // Divide longitude with 15 to get the hours.
        ST0 += longitude / 15;

        //Substract 24 hours to get a result between 0 and 24 hours: 0.1299018653
        let LST = ST0.truncatingRemainder(dividingBy: 24)
        return LST

    }

    func dateToJD(_ timestamp: TimeInterval) -> TimeInterval {
        timestamp / 86400000 + 2440587.5
    }

    func calculateFactorT(_ date: Date) -> (T: Double, deltaT: Double) {
        // http://radixpro.com/a4a-start/factor-t-and-delta-t/

        // factor T

        // date to JD
        let dateTime = date.timestamp
        let JD = dateToJD(dateTime)

        let T = (JD - 2451545) / 36525
        var deltaT: Double = 0.0
        var t: Double = 0.0

        let y = Double(date.getFullYear())

        if y < -500 {
            t = (y-1820)/100.0;
            deltaT = -20 + 32 * pow(t, 2)
            return (T: T, deltaT: deltaT)
        }
        if y >= -500 && y < 500 {
            t = y/100
            deltaT = 10583.6 - 1014.41 * t + 33.78311 * pow(t, 2) - 5.952053 * pow(t, 3) - 0.1798452 * pow(t, 4) + 0.022174192 * pow(t, 5) + 0.0090316521 * pow(t, 6);
            return (T: T, deltaT: deltaT)
        }
        if y >= 500 && y < 1600 {
            t = (y-1000)/100;
            deltaT = 1574.2 - 556.01 * t + 71.23472 * pow(t, 2) + 0.319781 * pow(t, 3) - 0.8503463 * pow(t, 4) - 0.005050998 * pow(t, 5) + 0.0083572073 * pow(t, 6);
            return (T: T, deltaT: deltaT)
        }
        if y >= 1600 && y < 1700 {
            t = y - 1600;
            deltaT = 120 - 0.9808 * t - 0.01532 * pow(t, 2) + pow(t, 3) / 7129;
            return (T: T, deltaT: deltaT)
        }
        if y >= 1700 && y < 1800 {
            t = y - 1700;
            deltaT = 8.83 + 0.1603 * t - 0.0059285 * pow(t, 2) + 0.00013336 * pow(t, 3) - pow(t, 4) / 1174000;
            return (T: T, deltaT: deltaT)
        }
        if y >= 1800 && y < 1860 {
            t = y - 1800;
            deltaT = 13.72 - 0.332447 * t + 0.0068612 * pow(t, 2) + 0.0041116 * pow(t, 3) - 0.00037436 * pow(t, 4) + 0.0000121272 * pow(t, 5) - 0.0000001699 * pow(t, 6) + 0.000000000875 * pow(t, 7);
            return (T: T, deltaT: deltaT)
        }
        if y >= 1860 && y < 1900 {
            t = y - 1860;
            deltaT = 7.62 + 0.5737 * t - 0.251754 * pow(t, 2) + 0.01680668 * pow(t, 3) - 0.0004473624 * pow(t, 4) + pow(t, 5) / 233174
            return (T: T, deltaT: deltaT)
        }
        if y >= 1900 && y < 1920 {
            t = y - 1900;
            deltaT = -2.79 + 1.494119 * t - 0.0598939 * pow(t, 2) + 0.0061966 * pow(t, 3) - 0.000197 * pow(t, 4)
            return (T: T, deltaT: deltaT)
        }
        if y >= 1920 && y < 1941 {
            t = y - 1920;
            deltaT = 21.20 + 0.84493*t - 0.076100 * pow(t, 2) + 0.0020936 * pow(t, 3)
            return (T: T, deltaT: deltaT)
        }
        if y >= 1941 && y < 1961 {
            t = y - 1950;
            deltaT = 29.07 + 0.407*t - pow(t, 2)/233 + pow(t, 3) / 2547
            return (T: T, deltaT: deltaT)
        }
        if y >= 1961 && y < 1986 {
            t = y - 1975;
            deltaT = 45.45 + 1.067*t - pow(t, 2)/260 - pow(t, 3) / 718
            return (T: T, deltaT: deltaT)
        }
        if y >= 1986 && y < 2005 {
            t = y - 1975;
            deltaT = 63.86 + 0.3345 * t - 0.060374 * pow(t, 2) + 0.0017275 * pow(t, 3) + 0.000651814 * pow(t, 4) + 0.00002373599 * pow(t, 5)
            return (T: T, deltaT: deltaT)
        }
        if y >= 2005 && y < 2050 {
            t = y - 2000;
            deltaT = 62.92 + 0.32217 * t + 0.005589 * pow(t, 2)
            return (T: T, deltaT: deltaT)
        }
        if y >= 2050 && y < 2150 {
            let powedY = ((y - 1820.0)/100.0) * ((y - 1820.0)/100.0)
            deltaT = -20.0 + 32.0 * powedY - 0.5628 * (2150.0 - y)
            return (T: T, deltaT: deltaT)
        }
        if y >= 2150 {
            t = (y-1820)/100;
            deltaT = -20 + 32 * pow(t, 2)
            return (T: T, deltaT: deltaT)
        }



        return (T: T, deltaT: deltaT)


    }
}

extension Date {
    var timestamp: TimeInterval {
        self.timeIntervalSince1970 * 1000
    }

    func getFullYear() -> Int {
        Calendar.current.component(.year, from: self)
    }
}
