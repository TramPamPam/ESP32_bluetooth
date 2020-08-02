//
//  BLEConnector.swift
//  Zori
//
//  Created by Oleksandr on 02.08.2020.
//  Copyright © 2020 ekreative. All rights reserved.
//

import Foundation
import CoreBluetooth
import SVProgressHUD

class BLEConnector: NSObject, Alertable {
    static let shared = BLEConnector()

    var device: Device?

    lazy var centralManager: CBCentralManager! = {
        return CBCentralManager(delegate: self, queue: nil)
    }()

    var peripheral: CBPeripheral!

    var onStatusChanged: ((String) -> Void)?
    var onOutputChanged: ((String) -> Void)?
    var onInputChanged: ((String) -> Void)?

    var current = CurrentInfo()

    func humanState() -> String {
        switch centralManager.state {
        case .unknown:
            return "unknown"
        case .resetting:
            return "resetting ..."
        case .unsupported:
            return "unsupported :|"
        case .unauthorized:
            return "unauthorized ><"
        case .poweredOff:
            return "POWER: OFF"
        case .poweredOn:
            return "POWER: ON"
        @unknown default:
            return "WTF"
        }
    }

    func refresh() {
        SVProgressHUD.show(withStatus: "refresh")
        guard centralManager.state == .poweredOn else {
            SVProgressHUD.showError(withStatus: "FAILED")
            return
        }

        centralManager.stopScan()
        centralManager.scanForPeripherals(withServices: nil)
        SVProgressHUD.show(withStatus: "scan")
    }

    func send(_ int: Int32) {
        let data = Data(toByteArray(int))
        debugPrint("sent", toByteArray(int))
//        canWriteCharacteristics.forEach {
//            peripheral.writeValue(data, for: $0, type: CBCharacteristicWriteType.withResponse)
//        }
    }

    func calibrate() {
        let arr: [UInt8] = [48, 1]
        let data = Data(arr)
//        canWriteCharacteristics.forEach {
//            peripheral.writeValue(data, for: $0, type: CBCharacteristicWriteType.withResponse)
//        }
    }

    func stopCalibrate() {
        let arr: [UInt8] = [48, 0]
        let data = Data(arr)
//        canWriteCharacteristics.forEach {
//            peripheral.writeValue(data, for: $0, type: CBCharacteristicWriteType.withResponse)
//        }
    }

    func send(azimuth: Angle, decline: Angle) {
        //        set current azimuth/decline - 0x20/0x21 (32/33)
        debugPrint(azimuth.degrees)
        debugPrint(decline.degrees)

        let deg: Int32 = Int32(azimuth.degrees * 200000)
        let lill: Int32 = deg.littleEndian
        var arr = toByteArray(lill)
        debugPrint(arr)

        var data = Data(arr)
//        canWriteCharacteristics.forEach {
//            peripheral.writeValue(data, for: $0, type: CBCharacteristicWriteType.withResponse)
//        }

        let degd: Int32 = Int32(decline.degrees * 200000)
        let lilld: Int32 = degd.littleEndian
        var arrd = toByteArray(lilld)
        debugPrint(arrd)

        data = Data(arrd)
//        canWriteCharacteristics.forEach {
//            peripheral.writeValue(data, for: $0, type: CBCharacteristicWriteType.withResponse)
//        }

    }

    func  toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafeBytes(of: &value) { Array($0) }
    }

    func fromByteArray<T>(_ value: [UInt8], _: T.Type) -> T {
        return value.withUnsafeBytes {
            $0.baseAddress!.load(as: T.self)
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension BLEConnector: CBCentralManagerDelegate {
    // MARK: update state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch centralManager.state {
        case .poweredOn:
            onStatusChanged?("central.state is \(humanState())")
        //            centralManager.scanForPeripherals(withServices: [serviceCBUUID])
        default:
            onStatusChanged?("central state is \(humanState())")
        }
    }

    // MARK: discover peripheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        SVProgressHUD.dismiss()

        guard peripheral.name != nil else { return }
        print(peripheral)

        debugPrint("Discovered? \(peripheral.name ?? "Unknown")")

        guard peripheral.name == "Zori" else { return }

        debugPrint("Discovered! \(peripheral.name ?? "Unknown")")

        self.peripheral = peripheral
        self.peripheral.delegate = self
        guard centralManager.state == .poweredOn else {
            showAlert("NOT CONNECTED `cause \(humanState())")
            return
        }
        centralManager.stopScan()
        centralManager.connect(self.peripheral)
    }

    // MARK: connect peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        debugPrint(" Connected! \(peripheral.name ?? "Unknown")")

        guard peripheral.name == "Zori" else { return }

        device = Device(peripheral: peripheral, active: true)

        onStatusChanged?(" Connected! \(peripheral.name ?? "Unknown")")

//        self.peripheral.discoverServices([serviceCBUUID])
        self.peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        device?.active = false
        onStatusChanged?("Failed to connect \(peripheral.name ?? "" )")
    }
}

// MARK: - CBPeripheralDelegate

extension BLEConnector: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            onStatusChanged?("No services for \(peripheral)")
            return
        }
        for service in services {
            debugPrint(service.uuid)
            peripheral.discoverCharacteristics(nil, for: service)
        }

        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "update"), object: nil)

    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        guard let services = peripheral.services else {
            onStatusChanged?("No services for \(peripheral)")
            return
        }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            onStatusChanged?("Discovered \(service) but no characteristics")
            return
        }

        device?.characteristics[service] = characteristics

        characteristics.forEach {
            device?.peripheral.setNotifyValue(true, for: $0)
        }

        do {
            try device?.getAvailableProperties(in: service)
        } catch {
            showError(error)
        }

        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "update"), object: nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if api[characteristic] == nil {
            debugPrint("Updated unknown \(characteristic.uuid.uuidString)")
        } else {
            debugPrint("Updated: \(api[characteristic]!)")
        }

        saveCharecteristic(characteristic: characteristic)

        if let service = api[characteristic], let value = characteristic.value {
            let stringValue = String(data: value, encoding: .utf8)
            service.set(stringValue)
        }
    }

    private func saveCharecteristic(characteristic: CBCharacteristic) {
        guard let char = characteristic.value, char.count > 1  else {
            SVProgressHUD.showSuccess(withStatus: "Ëmpty response")
            return
        }

//        let data = char.advanced(by: 1)
        if let string = String(data: char, encoding: .utf8) {
            SVProgressHUD.showSuccess(withStatus: string)
            onInputChanged?(string)
            save(string: string)
            if let service = Property(rawValue: characteristic.uuid.uuidString) {
                service.set(string)
            }
            return
        }

//        let int32: Int32 = data.withUnsafeBytes { $0.load(as: Int32.self) }
        let int32: Int32 = char.withUnsafeBytes { $0.load(as: Int32.self) }
        let value = Int(littleEndian: Int(int32))
        let fValue = Float(value)
        onInputChanged?(" AKA \(Float(fValue/200000)) | \(int32)")
        save(float: Float(fValue/200000))
        if let service = Property(rawValue: characteristic.uuid.uuidString) {
            service.set(Float(fValue/200000))
        }
        SVProgressHUD.dismiss()
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
    }


    func save(string: String) {
        guard let latestRaw = UserDefaults.standard.value(forKey: "latest") as? Int32, let property = ZoriProperties(rawValue: latestRaw) else {
            return
        }

        switch property {
        case .getSerial:
            current.serial = string
            UserDefaults.standard.removeObject(forKey: "latest")
        case .getFirmwareVersion:
            current.firmwareVersion = string
            UserDefaults.standard.removeObject(forKey: "latest")
        case .getHardwareVersion:
            current.hardwareVersion = string
            UserDefaults.standard.removeObject(forKey: "latest")
        default:
            break
        }


    }

    func save(float: Float) {
        guard let latestRaw = UserDefaults.standard.value(forKey: "latest") as? Int32, let property = ZoriProperties(rawValue: latestRaw) else { return }
        switch property {
        case .getAz:
            current.az = float
            UserDefaults.standard.removeObject(forKey: "latest")
        case .getDec:
            current.dec = float
            UserDefaults.standard.removeObject(forKey: "latest")
        default:
            break
        }

    }
}
