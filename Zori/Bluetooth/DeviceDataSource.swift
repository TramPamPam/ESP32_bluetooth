//
//  DeviceDataSource.swift
//  Zori
//
//  Created by Oleksandr on 02.08.2020.
//  Copyright © 2020 ekreative. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceDataSource: NSObject, UITableViewDataSource {
    var services: [CBService] {
        guard let keys = BLEConnector.shared.device?.characteristics.keys else {
            return []
        }
        return Array(keys)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        services[section].uuid.uuidString
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        debugPrint(services)
        return services.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        services[section].characteristics?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BleInfoCell", for: indexPath)
        cell.textLabel?.textColor = .white

        guard let rawValue = services[indexPath.section].characteristics?[indexPath.row].uuid.uuidString else {
            return cell
        }

//        cell.textLabel?.text = "Raw: \(rawValue)"

        if let property = Property(rawValue: rawValue) {
            cell.textLabel?.text = "Property: \(String(describing: property.value))"
        }

        return cell
    }


}
