//
//  ZoriCommands.swift
//  Zori
//
//  Created by Oleksandr on 12.01.2020.
//  Copyright © 2020 ekreative. All rights reserved.
//

/**
 Available commands:
 - 0x20/0x21 - установить азимут/наклон в градусах
 - calibrate - 0x3001 (start) - 12289
 - calibrate - 0x3000 - 12288 (stop)
 */
enum ZoriCommands: Int32 {
    case startCalibration = 0x0130
    case stopCalibration = 0x0030
    case setAz = 0x20
    case setDec = 0x21

    static var values: [ZoriCommands] {
        return [
        .startCalibration,
        .stopCalibration,
        .setAz,
        .setDec
        ]
    }

    static func stringValues() -> [String] {
        var res: [String] = []
        res.append(ZoriCommands.startCalibration.toString())
        res.append(ZoriCommands.stopCalibration.toString())
        res.append(ZoriCommands.setAz.toString())
        res.append(ZoriCommands.setDec.toString())
        return res
    }

    func toString() -> String {
        switch self {
        case .startCalibration:
            return "calibrate - \(rawValue) (start)"
        case .stopCalibration:
            return "calibrate - \(rawValue) (stop)"
        case .setAz:
            return "0x20 установить азимут в градусах"
        case .setDec:
            return "0x21 - установить наклон в градусах"
        }
    }
}
