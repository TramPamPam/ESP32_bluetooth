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
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var serviceStatusLabel: UILabel!
    
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
    
    @IBAction func sendTapped(_ sender: UIButton) {
        send(string: sender.titleLabel!.text!)
    }
    
    func send(string: String) {
        let data = string.data(using: .utf8)!
        
        canWriteCharacteristics.forEach {
            peripheral.writeValue(data, for: $0, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    func onHeartRateReceived(_ heartRate: Int) {
        inputLabel.text = String(heartRate)
        print("BPM: \(heartRate)")
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
        if let data = characteristic.value, let string = String(data: data, encoding: .utf8) {
            inputLabel.text! += string
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
