//
//  PeripheryTableViewController.swift
//  Zori
//
//  Created by Oleksandr on 20.09.2020.
//  Copyright © 2020 zori. All rights reserved.
//

import UIKit
import CoreBluetooth

final class PeripheryTableViewController: UITableViewController, Alertable {
    var services: [CBService] {
        guard let keys = BLEConnector.shared.device?.characteristics.keys else {
            return []
        }
        return Array(keys.filter { $0.characteristics != nil })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: CharacteristicTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CharacteristicTableViewCell.reuseIdentifier)

        BLEConnector.shared.device?.peripheral.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        services.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !services.isEmpty else {
            return "No services"
        }
        if let human = Property(rawValue: services[section].uuid.uuidString.lowercased()) {
            return "Service: \(human)"
        }
        return "Service: \(services[section].uuid.uuidString)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        services[section].characteristics!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !services.isEmpty else {
            let errCell = UITableViewCell(style: .default, reuseIdentifier: "errorcell");
            errCell.textLabel?.text = "No services";
            return errCell;
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: CharacteristicTableViewCell.reuseIdentifier, for: indexPath)
        let characteristic = services[indexPath.section].characteristics![indexPath.row]
        let canRead = characteristic.properties.contains(.read)
        let canWrite = characteristic.properties.contains(.write)
        var title = characteristic.uuid.uuidString
        if let human = Property(rawValue: title.lowercased()) {
            title = "\(human)"
        } else {
            debugPrint("non human: \(title)")
        }

        let valueBytes = characteristic.value?.bytes ?? []
        let value = services[indexPath.section].uuid.uuidString.lowercased() != Property.device_information.rawValue ? "Value: \(valueBytes)" : String(bytes: valueBytes, encoding: .utf8)

        (cell as? CharacteristicTableViewCell)?.fill(
            title: title,
            subtitle: value ?? "none",
            canRead: canRead,
            readAction: { self.handleRead(indexPath) },
            canWrite: canWrite,
            writeAction: { self.handleWrite(indexPath) }
        )
        return cell
    }

    func handleRead(_ indexPath: IndexPath) -> Void {
        let characteristic = services[indexPath.section].characteristics![indexPath.row]
        BLEConnector.shared.device!.peripheral.readValue(for: characteristic)
    }

    func handleWrite(_ indexPath: IndexPath) -> Void {
        let characteristic = services[indexPath.section].characteristics![indexPath.row]

        showAlert("Enter value for ") { (value) in
            guard let aValue = value, let intValue = UInt32(aValue) else {
                self.showAlert("Wrong value: \(String(describing: value))")
                return
            }
            var anInt = intValue
            let data = Data(bytes: &anInt,
                            count: MemoryLayout.size(ofValue: anInt))
            BLEConnector.shared.device!.peripheral.writeValue(data, for: characteristic, type: .withResponse)

        }
    }

}

// MARK: - CBPeripheralDelegate
extension PeripheryTableViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        var log = "\(#function) :: \(String(describing: error))"
        let humanCharacteristic = Property(rawValue: characteristic.uuid.uuidString.lowercased())!
        log.append("\ncharacteristic: \(humanCharacteristic)")
        log.append("\nvalue: \(characteristic.value?.bytes ?? []) @ \(Date()) ")
        logs.append(log)

        debugPrint("\(#function) :: \(error)")
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
            res.append("No value \(characteristic.value?.bytes ?? [])")
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        var log = "\(#function) :: \(String(describing: error))"

        let humanCharacteristic = Property(rawValue: characteristic.uuid.uuidString.lowercased())!
        log.append("\ncharacteristic: \(humanCharacteristic)")
        log.append("\nvalue: \(characteristic.value?.bytes ?? []) @ \(Date())")
        logs.append(log)
        debugPrint(log)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
        tableView.reloadData()
    }
}

typealias Byte = UInt8
enum Bit: Int {
    case zero, one
}

extension Data {
    var bytes: [Byte] {
        var byteArray = [UInt8](repeating: 0, count: self.count)
        self.copyBytes(to: &byteArray, count: self.count)
        return byteArray
    }
}

extension Byte {
    var bits: [Bit] {
        let bitsOfAbyte = 8
        var bitsArray = [Bit](repeating: Bit.zero, count: bitsOfAbyte)
        for (index, _) in bitsArray.enumerated() {
            // Bitwise shift to clear unrelevant bits
            let bitVal: UInt8 = 1 << UInt8(bitsOfAbyte - 1 - index)
            let check = self & bitVal

            if check != 0 {
                bitsArray[index] = Bit.one
            }
        }
        return bitsArray
    }
}
