//
//  BLE.swift
//  Zori
//
//  Created by Oleksandr on 9/12/18.
//  Copyright © 2018 ekreative. All rights reserved.
//
import Foundation
import CoreBluetooth
import SVProgressHUD

//let serviceCBUUID = CBUUID(string: "2b5e100a-2e9e-11e8-b467-0ed5f89f718b")
//let espInCharacteristicCBUUID = CBUUID(string: "6e3e4a02-2e9e-11e8-b467-0ed5f89f718b") //in
//let espOutCharacteristicCBUUID = CBUUID(string: "72c31af8-2e9e-11e8-b467-0ed5f89f718b") //out

let serviceCBUUID = CBUUID(string: Property.primary_device_service.rawValue)
let espInCharacteristicCBUUID = CBUUID(string: Property.device_status.rawValue) //in
let espOutCharacteristicCBUUID = CBUUID(string: Property.device_command.rawValue) //out

enum Property: String {
    ///Manufacturer:
    case manufacturer = "org.bluetooth.characteristic.manufacturer_name_string"
    
    ///Primary Device Service    org.bluetooth.service.primary_device_service
    case primary_device_service = "2b5e100a-2e9e-11e8-b467-0ed5f89f718b"

    //Primary Service Read Characteristics:
    ///Device Status    org.bluetooth.characteristic.device_status
    case device_status = "2b5e2a00-2e9e-11e8-b467-0ed5f89f718b"

    ///Device Error Code    org.bluetooth.characteristic.device_error_code
    case device_error_code = "2b5e2a02-2e9e-11e8-b467-0ed5f89f718b"

    ///Device Azimut Value    org.bluetooth.characteristic.device_azimut_value
    case device_azimut_value = "2b5e2a03-2e9e-11e8-b467-0ed5f89f718b"

    ///Device Decline Value    org.bluetooth.characteristic.device_decline_value
    case device_decline_value = "2b5e2a04-2e9e-11e8-b467-0ed5f89f718b"

    ///Device Laser Intensity Value    org.bluetooth.characteristic.device_laser_intensity_value
    case device_laser_intensity_value = "2b5e2a05-2e9e-11e8-b467-0ed5f89f718b"

    //Primary Service Write Characteristics:
    ///Device Command    org.bluetooth.characteristic.device_command
    case device_command = "2b5e4a00-2e9e-11e8-b467-0ed5f89f718b"

    ///Device Parameters    org.bluetooth.characteristic.device_parameters
    case device_parameters = "2b5e4a01-2e9e-11e8-b467-0ed5f89f718b"

    ///Device Azimut Task   org.bluetooth.characteristic.device_azimut_task
    case device_azimut_task = "2b5e4a03-2e9e-11e8-b467-0ed5f89f718b"

    ///Device Decline Task    org.bluetooth.characteristic.device_decline_task
    case device_decline_task = "2b5e4a04-2e9e-11e8-b467-0ed5f89f718b"

    ///Device Laser Intensity Task    org.bluetooth.characteristic.device_laser_intensity_task
    case device_laser_intensity_task = "2b5e4a05-2e9e-11e8-b467-0ed5f89f718b"

    ///Device Led Task    org.bluetooth.characteristic.device_led_task
    case device_led_task = "2b5e4a06-2e9e-11e8-b467-0ed5f89f718b"

    ///Magnetic Declination    org.bluetooth.characteristic.magnetic_declination
    case magnetic_declination = "2b5e4a07-2e9e-11e8-b467-0ed5f89f718b"

    ///Device Mode    org.bluetooth.characteristic.device_mode
    case device_mode = "2b5e8a00-2e9e-11e8-b467-0ed5f89f718b"

    var value: Any? {
        UserDefaults.standard.value(forKey: rawValue)
    }
    
    func set(_ value: Any?) {
        UserDefaults.standard.set(value, forKey: rawValue)
        if value != nil {
            debugPrint("Saved \(value!) in \(self)")
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "update"), object: nil)
        }

    }

    static let read: [Self] = [
        .device_status,
        .device_error_code,
        .device_azimut_value,
        .device_decline_value,
        .device_laser_intensity_value,
    ]

    static let write: [Self] = [
        .device_command,
        .device_parameters,
        .device_azimut_task,
        .device_decline_task,
        .device_laser_intensity_task,
        .device_led_task,
        .magnetic_declination,
        .device_mode,
    ]

    static let allCharecteristics: [Self] = [
        ///Read
        .device_status,
        .device_error_code,
        .device_azimut_value,
        .device_decline_value,
        .device_laser_intensity_value,

        ///Write
        .device_command,
        .device_parameters,
        .device_azimut_task,
        .device_decline_task,
        .device_laser_intensity_task,
        .device_led_task,
        .magnetic_declination,
        .device_mode,
    ]
}

struct CurrentInfo {
    var serial: String?
    var firmwareVersion: String?
    var hardwareVersion: String?
    var az: Float?
    var dec: Float?
}

var api = [CBCharacteristic: Property]()
