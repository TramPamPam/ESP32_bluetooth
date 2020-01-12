//
//  ZoriProperties.swift
//  Zori
//
//  Created by Oleksandr on 12.01.2020.
//  Copyright © 2020 ekreative. All rights reserved.
//

/**
 Available commands:

 - get serial - 0x10
 - get firmware version - 0x11
 - get hardware version - 0x12
 - 0x40/0x41 - получить текущий азимут/наклон
 - 0x20/0x21 - установить азимут/наклон в градусах
 - calibrate - 0x3001 (start) - 12289, 0x3000 - 12288 (stop)
 */
enum ZoriProperties: Int32 {
    case getSerial = 0x10
    case getFirmwareVersion = 0x11
    case getHardwareVersion = 0x12
    case getAz = 0x40
    case getDec = 0x41

    static var values: [ZoriProperties] {
        return [
        .getSerial,
        .getFirmwareVersion,
        .getHardwareVersion,
        .getAz,
        .getDec
        ]
    }

    static func stringValues() -> [String] {
        var res: [String] = []
        res.append(ZoriProperties.getSerial.toString())
        res.append(ZoriProperties.getHardwareVersion.toString())
        res.append(ZoriProperties.getFirmwareVersion.toString())
        res.append(ZoriProperties.getAz.toString())
        res.append(ZoriProperties.getDec.toString())
        return res
    }

    func toString() -> String {
        switch self {
        case .getSerial:
            return "get serial - 0x10"
        case .getFirmwareVersion:
            return "get firmware version - 0x11"
        case .getHardwareVersion:
            return "get hardware version - 0x12"
        case .getAz:
            return "get current azimuth - 0x40"
        case .getDec:
            return "get current decline - 0x41"
        }
    }

    static func from(string: String) -> ZoriProperties? {

        switch string {
        case  "get serial - 0x10":
            return .getSerial
        case "get firmware version - 0x11":
            return .getFirmwareVersion
        case "get hardware version - 0x12":
            return .getHardwareVersion
        case "get current azimuth - 0x40":
            return .getAz
        case "get current decline - 0x41":
            return .getDec
        default:
            return nil
        }

    }
}
