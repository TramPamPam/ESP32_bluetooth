
//
//  BLECommands+DataSource.swift
//  Zori
//
//  Created by Oleksandr on 6/30/19.
//  Copyright © 2019 ekreative. All rights reserved.
//
import UIKit
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
}

/**
 Available commands:
 - 0x20/0x21 - установить азимут/наклон в градусах
 - calibrate - 0x3001 (start) - 12289
 - calibrate - 0x3000 - 12288 (stop)
 */
enum ZoriCommands: Int32 {
    case startCalibration = 0x3001
    case stopCalibration = 0x3000
    case setAz = 0x20
    case setDec = 0x21

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
            return "calibrate - 0x3001 (start)"
        case .stopCalibration:
            return "calibrate - 0x3000"
        case .setAz:
            return "0x20 установить азимут в градусах"
        case .setDec:
            return "0x21 - установить наклон в градусах"
        }
    }
}

class BLEDataSource: NSObject, UITableViewDataSource {
    let props = ZoriProperties.stringValues()
    let commands = ZoriCommands.stringValues()

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Available properties: "
        default:
            return "Available commands: "
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return props.count
        case 1:
            return commands.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BleInfoCell", for: indexPath)
        cell.textLabel?.textColor = .white
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = props[indexPath.row]
        default:
            cell.textLabel?.text = commands[indexPath.row]
        }
        return cell
    }

    
}
