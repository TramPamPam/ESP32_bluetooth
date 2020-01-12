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

    @IBOutlet private weak var joystickBackImageView: UIImageView!
    @IBOutlet private weak var joystickView: JoystickView!
    @IBOutlet private weak var joystickThumbView: UIView!

    @IBOutlet private weak var indicatorXLabel: UILabel!
    @IBOutlet private weak var indicatorYLabel: UILabel!
    @IBOutlet private weak var directionLabel: UILabel!

    @IBOutlet private weak var latestCommandLabel: UILabel!

    var item = DispatchWorkItem() {}

    override func viewDidLoad() {
        super.viewDidLoad()

        joystickView.joystickBg = joystickBackImageView

        joystickView.joystickThumb = joystickThumbView

        joystickView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension JoystickViewController: JoystickViewDelegate {
    func joystickView(_ joystickView: JoystickView, didMoveto x: Float, y: Float, direction: JoystickMoveDriection) {
        indicatorXLabel.text = "\((x * 100).rounded())"
        indicatorYLabel.text = "\((y * 100).rounded())"
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
        guard x != 0 && y != 0 else { return }
        item.cancel()
        item = DispatchWorkItem() { [weak self, x = x, y = y] in
            self?.latestCommandLabel.text = "Latest command:\nMoving x: \((x * 100).rounded()) y: \((y * 100).rounded())"
//            debugPrint("Moving x: \((x * 100).rounded()) y: \((y * 100).rounded())")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: item)
    }

    func joystickViewDidEndMoving(_ joystickView: JoystickView) {
        directionLabel.text = "Stopped"
    }
}

