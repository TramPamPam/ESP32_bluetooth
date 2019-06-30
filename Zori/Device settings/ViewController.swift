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
    @IBOutlet weak var customCommandTextField: UITextField!
    
    @IBOutlet weak var connectionSwitch: UISwitch!

    @IBOutlet weak var infoTableView: UITableView!
    
    let infoSource = BLEDataSource()
    let central = BLEConnector.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        central.onStatusChanged = { self.serviceStatusLabel.text = $0 }
        central.onOutputChanged = { self.statusLabel.text = $0 }
        central.onInputChanged = { self.inputLabel.text = $0 }
        
        // Make the digits monospaces to avoid shifting when the numbers change
        inputLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: inputLabel.font!.pointSize, weight: .regular)

        infoTableView?.dataSource = infoSource
        infoTableView?.reloadData()
    }
    
    @IBAction private func refreshTapped(_ sender: UIButton) {
        central.refresh()
    }

//    Available commands:
//
//
//    get serial - 0x10
//    get firmware version - 0x11
//    get hardware version - 0x12
//    set coordinates - 0x20 (2x8 bytes float data?)
//    0x40/0x41 - получить текущий азимут/наклон
//    0x20/0x21 - установить азимут/наклон в градусах
//    calibrate - 0x3001 (start) - 12289, 0x3000 - 12288 (stop)
    //    
    @IBAction func sendTapped(_ sender: UIButton) {
        central.send(Int32(sender.tag))
    }

    @IBAction func calibrateTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.isSelected ? central.calibrate() : central.stopCalibrate()
    }

    @IBAction func startCalibrateTapped(_ sender: Any) {
        central.calibrate()
    }
    
    @IBAction func stopCalibrateTapped(_ sender: Any) {
        central.stopCalibrate()
    }
    
    @IBAction func customCommandSend(_ sender: UIButton) {
        defer {
            customCommandTextField.resignFirstResponder()
        }
        guard let commandString = customCommandTextField.text else {
            return
        }
        guard let command = Int32(commandString) else {
            return
        }
        central.send(command)

    }

    @IBAction func switchChanged(_ sender: UISwitch) {
        connectionSwitch.isOn ? central.refresh() : central.send(12288)
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
}



