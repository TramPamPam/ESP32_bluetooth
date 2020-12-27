//
//  CurrentStatusViewController.swift
//  Zori
//
//  Created by Oleksandr on 12.01.2020.
//  Copyright © 2020 ekreative. All rights reserved.
//

import UIKit

class CurrentStatusViewController: UIViewController {

    @IBOutlet weak var serialLabel: UILabel!

    @IBOutlet weak var firmwareLabel: UILabel!

    @IBOutlet weak var hardwareLabel: UILabel!

    @IBOutlet weak var azLabel: UILabel!

    @IBOutlet weak var decLabel: UILabel!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let info = BLEConnector.shared.current
        serialLabel.text = info.serial ?? "n/a"
        firmwareLabel.text = info.firmwareVersion ?? "n/a"
        hardwareLabel.text = info.hardwareVersion ?? "n/a"
        azLabel.text = info.az != nil ? "\(info.az!)" : "n/a"
        decLabel.text = info.dec != nil ? "\(info.dec!)" : "n/a"

    }

    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
