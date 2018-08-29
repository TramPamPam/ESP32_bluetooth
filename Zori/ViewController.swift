//
//  ViewController.swift
//  Zori
//
//  Created by Oleksandr Bezpalchuk on 4/10/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import UIKit
import CoreBluetooth

let serviceCBUUID = CBUUID(string: "2b5e100a-2e9e-11e8-b467-0ed5f89f718b")
let espInCharacteristicCBUUID = CBUUID(string: "6e3e4a02-2e9e-11e8-b467-0ed5f89f718b") //in
let espOutCharacteristicCBUUID = CBUUID(string: "72c31af8-2e9e-11e8-b467-0ed5f89f718b") //out

class ViewController: UIViewController {
    
    @IBOutlet weak var degreeX: UITextField!
    @IBOutlet weak var minuteX: UITextField!
    @IBOutlet weak var secondsX: UITextField!
    
    @IBOutlet weak var degreesY: UITextField!
    @IBOutlet weak var minutesY: UITextField!
    @IBOutlet weak var secondsY: UITextField!
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var serviceStatusLabel: UILabel!
    @IBOutlet weak var customCommandTextField: UITextField!
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var characteristics: [CBCharacteristic] = []
    var canWriteCharacteristics: [CBCharacteristic] = []
    var canReadCharacteristics: [CBCharacteristic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Make the digits monospaces to avoid shifting when the numbers change
        inputLabel.font = UIFont.monospacedDigitSystemFont(ofSize: inputLabel.font!.pointSize, weight: .regular)
    }
    
    @IBAction private func refreshTapped(_ sender: UIButton) {
        centralManager = CBCentralManager(delegate: self, queue: nil)

        centralManager.stopScan()
        centralManager.scanForPeripherals(withServices: [serviceCBUUID])
    }

//    Available commands:
//
//
//    get serial - 0x10
//    get firmware version - 0x11
//    get hardware version - 0x12
//    set coordinates - 0x20 (2x8 bytes float data?)
    @IBAction func sendTapped(_ sender: UIButton) {
        send(UInt8(sender.tag))
    }
    
    @IBAction func customCommandSend(_ sender: UIButton) {
        send(UInt8(customCommandTextField.text!)!)
        customCommandTextField.resignFirstResponder()
    }
    
    func send(_ int: UInt8) {
        let data = Data(toByteArray(int))
        debugPrint(toByteArray(int))
        canWriteCharacteristics.forEach {
            peripheral.writeValue(data, for: $0, type: CBCharacteristicWriteType.withResponse)
        }
        
    }
    
    func onHeartRateReceived(_ heartRate: Int) {
        inputLabel.text = String(heartRate)
        print("BPM: \(heartRate)")
    }
    
    func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafeBytes(of: &value) { Array($0) }
    }
    
    func fromByteArray<T>(_ value: [UInt8], _: T.Type) -> T {
        return value.withUnsafeBytes {
            $0.baseAddress!.load(as: T.self)
        }
    }
    
}

//MARK: - CBCentralManagerDelegate

extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            statusLabel.text = "central.state is .unknown"
        case .resetting:
            statusLabel.text = "central.state is .resetting"
        case .unsupported:
            statusLabel.text = "central.state is .unsupported"
        case .unauthorized:
            statusLabel.text = "central.state is .unauthorized"
        case .poweredOff:
            statusLabel.text = "central.state is .poweredOff"
        case .poweredOn:
            statusLabel.text = "central.state is .poweredOn"
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
 
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        guard peripheral.name == "Zori" else { return }
        
        statusLabel.text! = "Discovered! \(peripheral.name ?? "Unknown")"

        self.peripheral = peripheral
        self.peripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(self.peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard peripheral.name == "Zori" else { return }
        statusLabel.text! = " Connected! \(peripheral.name ?? "Unknown")"
        self.peripheral.discoverServices([serviceCBUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        debugPrint(error)
        serviceStatusLabel.text = "Failed to connect \(peripheral.name ?? "" )"
    }
}

// MARK: - CBPeripheralDelegate

extension ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            serviceStatusLabel.text = "No services for \(peripheral)"
            return
        }
        serviceStatusLabel.text = "Discovered \(services) for \(peripheral)"
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            serviceStatusLabel.text = "Discovered \(service) but no characteristics"
            return
        }
        self.characteristics = characteristics
        for characteristic in characteristics {
//            print(characteristic)
            debugPrint(characteristic.properties)
            if characteristic.properties.contains(.read) {
                self.canReadCharacteristics.append(characteristic)
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.write) {
                self.canWriteCharacteristics.append(characteristic)
                print("\(characteristic.uuid): properties contains .write")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        serviceStatusLabel.text = "Discovered: readable \(canReadCharacteristics.count)\nwritable: \(canWriteCharacteristics.count)"
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case espInCharacteristicCBUUID:
            debugPrint("IN -- ok")
        case espOutCharacteristicCBUUID:
            debugPrint("OUT -- ok")
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
        if let char = characteristic.value, char.count > 0  {
            debugPrint(char[0])
        
            if let dataString = characteristic.value?.advanced(by: 1),
                let string = String(data: dataString, encoding: .utf8) {
                inputLabel.text! = string
            }
            if let data = characteristic.value?.advanced(by: 1) {
                let int32: Int32 = data.withUnsafeBytes({ (point) -> Int32 in
                    return point.pointee
                })
                let value = Int(littleEndian: Int(int32))
                let fValue = Float(value)
                inputLabel.text?.append(" AKA \(Float(fValue/200000)) | \(int32)")
            }
            
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        let alertController = UIAlertController(title: "YAY", message: "Did write for \(descriptor.characteristic)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
}



