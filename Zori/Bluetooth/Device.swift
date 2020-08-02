//
//  Device.swift
//  Zori
//
//  Created by Oleksandr on 02.08.2020.
//  Copyright © 2020 ekreative. All rights reserved.
//

import CoreBluetooth
import Foundation

struct Device {
    var peripheral: CBPeripheral

    var active = false

    /// Computed values:
    var services: [CBService] {
        peripheral.services ?? []
    }

    var characteristics: [CBService: [CBCharacteristic]] = [:]

    var name: String {
        peripheral.name ?? "None"
    }

    func getCurrentServices() -> [CBService: [CBCharacteristic]] {
        var res: [CBService: [CBCharacteristic]] = [:]
        services.forEach {
            res[$0] = $0.characteristics
        }
        return res
    }

    func getAvailableProperties(in service: CBService) throws {
        guard let characteristics = characteristics[service] else {
            return
        }

        characteristics.forEach {
            api[$0] = Property(rawValue: $0.uuid.uuidString.lowercased())
        }

        let got = characteristics.compactMap { Property(rawValue: $0.uuid.uuidString.lowercased()) }

        let missing = Property.allCharecteristics.filter { !got.contains($0) }

        debugPrint("Missing: \(missing)")

        guard missing.isEmpty else { throw CustomError.missingField(field: "\(got.count) out of \(Property.allCharecteristics.count)") }
    }

}

