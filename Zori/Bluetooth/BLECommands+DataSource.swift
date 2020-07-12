
//
//  BLECommands+DataSource.swift
//  Zori
//
//  Created by Oleksandr on 6/30/19.
//  Copyright © 2019 ekreative. All rights reserved.
//
import UIKit

struct BleModel {
    let title: String
    let source: Services

    init(service: Services) {
        if let currentValue = service.value {
            title = "\(service) : \(currentValue)"
        } else {
            title = "\(service) : NaN"
        }
        source = service
    }
}

class BLEDataSource: NSObject, UITableViewDataSource {
    let props = Services.read.map { BleModel(service: $0) } // ZoriProperties.stringValues()
    let commands = Services.write.map { BleModel(service: $0) } // ZoriCommands.stringValues()

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Available properties (read): "
        default:
            return "Available commands (write): "
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
            cell.textLabel?.text = props[indexPath.row].title
        default:
            cell.textLabel?.text = commands[indexPath.row].title
        }
        return cell
    }

}
