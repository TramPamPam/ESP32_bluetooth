//
//  DeviceCommandViewController.swift
//  Zori
//
//  Created by Oleksandr on 06.09.2020.
//  Copyright © 2020 zori. All rights reserved.
//

import UIKit
import CoreBluetooth

var logs: [String] = []

enum DeviceCommand: Int {
    /**
     0x00
     APPS_DEV_CMD_NONE
     NOP command
     No OPeration function
    */
    case none

    /**
     0x01
     APPS_DEV_CMD_MOVE_TO
     Move To command
     Move in Azimut("Device Azimut Task"), Decline("Device Decline Task") point
     */
    case moveTo

     /**
     0x02
     APPS_DEV_CMD_MOVE_BY_POINTS
     Move By Point commant
     Move by Azimut("Device Azimut Task"), Decline("Device Decline Task") points, up to 10 in queue
     */
    case moveByPoints

     /**
     0x03
     APPS_DEV_CMD_STOP
     Stop Moving command
     Stop moving after reaching current Azimut("Device Azimut Task"), Decline("Device Decline Task") point, and clear queue of points
     */
    case stop

     /**
     0x04
     APPS_DEV_CMD_HARD_STOP
     Hard Stop Moving command
     Stop moving immediately
     */
    case hardStop
}

final class DeviceCommandViewController: UIViewController, Alertable {

    @IBOutlet private weak var deviceParamsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        BLEConnector.shared.peripheral?.delegate = self
    }

    @IBAction private func selectCommand(_ sender: UIButton) {
        guard let command = DeviceCommand(rawValue: sender.tag) else {
            showAlert("Wrong command \(sender.tag)");
            return
        }

        handle(command: command)

    }

    private func handle(command: DeviceCommand) {
        guard let device = BLEConnector.shared.device else {
            showAlert("Device not found")
            return
        }

        guard let service = device.services.first(where: {
            $0.uuid.uuidString.lowercased() == Property.primary_device_service.rawValue
        }) else {
            showAlert("Service not found")
            return
        }

        guard let characterstic = service.characteristics?.first(where: {
            $0.uuid.uuidString.lowercased() == Property.device_command.rawValue
        }) else {
            showAlert("characterstic not found")
            return
        }

        switch command {
        case .moveTo, .moveByPoints:
            setAzAndDec(command: command.rawValue)
        default:
            var tagInt = UInt8(command.rawValue)
            let tagIntData = Data(bytes: &tagInt,
                                   count: MemoryLayout.size(ofValue: tagInt))
            BLEConnector.shared.peripheral.writeValue(tagIntData, for: characterstic, type: CBCharacteristicWriteType.withResponse)
        }
    }

    private func move(command: Int, az: UInt32, dec: UInt32) {
        guard let device = BLEConnector.shared.device else {
            showAlert("Device not found")
            return
        }

        guard let service = device.services.first(where: {
            $0.uuid.uuidString.lowercased() == Property.primary_device_service.rawValue
        }) else {
            showAlert("Service not found")
            return
        }

        guard let characterstic = service.characteristics?.first(where: {
            $0.uuid.uuidString.lowercased() == Property.device_command.rawValue
        }) else {
            showAlert("characterstic not found")
            return
        }

        //Set az and dec befoe move:
        var azInt = az
        let myIntData = Data(bytes: &azInt,
                             count: MemoryLayout.size(ofValue: azInt))

        guard let azimuth = service.characteristics?.first(where: {
            $0.uuid.uuidString.lowercased() == Property.device_azimut_task.rawValue
        }) else {
            showAlert("device_azimut_value not found")
            return
        }
        BLEConnector.shared.peripheral.writeValue(myIntData, for: azimuth, type: CBCharacteristicWriteType.withResponse)

        var decInt = dec
        let decIntData = Data(bytes: &decInt,
                             count: MemoryLayout.size(ofValue: decInt))
        guard let decline = service.characteristics?.first(where: {
            $0.uuid.uuidString.lowercased() == Property.device_decline_task.rawValue
        }) else {
            showAlert("device_decline_value not found")
            return
        }
        BLEConnector.shared.peripheral.writeValue(decIntData, for: decline, type: CBCharacteristicWriteType.withResponse)

        debugPrint(device.services.map { "\($0.uuid) - \($0.characteristics?.count ?? -1)" } )
        debugPrint(command)

        var tagInt = UInt8(command)
        let tagIntData = Data(bytes: &tagInt,
                               count: MemoryLayout.size(ofValue: tagInt))
        BLEConnector.shared.peripheral.writeValue(tagIntData, for: characterstic, type: CBCharacteristicWriteType.withResponse)


        switch command {
            //        0x00
            //        APPS_DEV_CMD_NONE
            //        NOP command
        //        No OPeration function
        case 0:
            logs.append("Sent : APPS_DEV_CMD_NONE @ \(Date())")
            debugPrint("Sent : APPS_DEV_CMD_NONE")

            //        0x01
            //        APPS_DEV_CMD_MOVE_TO
            //        Move To command
        //        Move in Azimut("Device Azimut Task"), Decline("Device Decline Task") point
        case 1 :
            logs.append("Sent : APPS_DEV_CMD_MOVE_TO @ \(Date())")
            debugPrint( "APPS_DEV_CMD_MOVE_TO" )



            //        0x02
            //        APPS_DEV_CMD_MOVE_BY_POINTS
            //        Move By Point commant
        //        Move by Azimut("Device Azimut Task"), Decline("Device Decline Task") points, up to 10 in queue
        case 2 :
            logs.append("Sent: APPS_DEV_CMD_MOVE_BY_POINTS @ \(Date())")
            debugPrint( "APPS_DEV_CMD_MOVE_BY_POINTS" )


            //        0x03
            //        APPS_DEV_CMD_STOP
            //        Stop Moving command
        //        Stop moving after reaching current Azimut("Device Azimut Task"), Decline("Device Decline Task") point, and clear queue of points
        case 3 :
            logs.append("Sent: APPS_DEV_CMD_STOP @ \(Date())")
            debugPrint( "APPS_DEV_CMD_STOP" )



            //        0x04
            //        APPS_DEV_CMD_HARD_STOP
            //        Hard Stop Moving command
        //        Stop moving immediately
        case 4:
            logs.append("Sent: APPS_DEV_CMD_HARD_STOP @ \(Date())")
            debugPrint( "APPS_DEV_CMD_HARD_STOP" )

        default :
            break

        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updates"), object: nil)
    }

    private func setAzAndDec(command: Int) {
        showDoubleTextFieldAlert("Set az and dec") { (az, dec) in
            guard !az.isEmpty, !dec.isEmpty else { return }
            self.move(command: command, az: UInt32(az)!, dec: UInt32(dec)!)
        }
    }
}
extension DeviceCommandViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        var log = "\(#function) :: \(String(describing: error))"
        let humanCharacteristic = Property(rawValue: characteristic.uuid.uuidString.lowercased())!
        log.append("\ncharacteristic: \(humanCharacteristic)")
        log.append("\nvalue: \(characteristic.uuid.data.bytes) @ \(Date())")
        logs.append(log)

        debugPrint("\(#function) :: \(error)")
        debugPrint(Property(rawValue: characteristic.uuid.uuidString.lowercased()))
        debugPrint(characteristic.value)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)

        guard let property = Property(rawValue: characteristic.uuid.uuidString.lowercased()), property != .device_command else {
            return
        }
        var res = ""
        res.append("Property: \(property)\n")

        if let err = error {
            res.append("\(err)\n")
        }

        if let value = characteristic.value ,
            let stringInt = String.init(data: value, encoding: String.Encoding.utf8) {
            res.append("Value: \(stringInt)\n")
        } else {
            res.append("No value \(characteristic.value )")
        }
        deviceParamsLabel.text = res
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        var log = "\(#function) :: \(String(describing: error))"
        let humanCharacteristic = Property(rawValue: characteristic.uuid.uuidString.lowercased())!
        log.append("\ncharacteristic: \(humanCharacteristic)")
        log.append("\nvalue: \(characteristic.value?.bytes) @ \(Date())")
        logs.append(log)
        debugPrint(log)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
    }
}
