
//
//  BLECommands+DataSource.swift
//  Zori
//
//  Created by Oleksandr on 6/30/19.
//  Copyright © 2019 ekreative. All rights reserved.
//
import UIKit

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
