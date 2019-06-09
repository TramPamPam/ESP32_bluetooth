//
//  JoystickViewController.swift
//  Zori
//
//  Created by Oleksandr on 6/9/19.
//  Copyright © 2019 ekreative. All rights reserved.
//

import UIKit
import JoystickView

class JoystickViewController: UIViewController {

    @IBOutlet weak var joystickBackImageView: UIImageView!

    @IBOutlet weak var joystickView: JoystickView!

    @IBOutlet weak var joystickThumbView: UIView!


    @IBOutlet weak var indicatorXLabel: UILabel!
    @IBOutlet weak var indicatorYLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        joystickView.joystickBg = joystickBackImageView

        joystickView.joystickThumb = joystickThumbView

        joystickView.delegate = self
    }
}

extension JoystickViewController: JoystickViewDelegate {



    func joystickView(_ joystickView: JoystickView, didMoveto x: Float, y: Float, direction: JoystickMoveDriection) {
        indicatorXLabel.text = "\(x)"
        indicatorYLabel.text = "\(y)"
        var directionHuman: String
        switch direction {
        case .none:
            directionHuman = "none"
        case .up:
            directionHuman = "up"
        case .down:
            directionHuman = "down"
        case .left:
            directionHuman = "left"
        case .right:
            directionHuman = "right"
        case .diagonal:
            directionHuman = "diagonal"
        }
        directionLabel.text = directionHuman
    }

    func joystickViewDidEndMoving(_ joystickView: JoystickView) {

        directionLabel.text = "Stopped"

    }
}

