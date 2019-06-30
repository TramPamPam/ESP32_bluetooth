//
//  CircleLoaderViewController.swift
//  Zori
//
//  Created by Oleksandr on 6/23/19.
//  Copyright © 2019 ekreative. All rights reserved.
//

import UIKit

class CircleLoaderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        addStar()
        addAnimation(radius: 190, isClockwise: true)
        addAnimation(radius: 150, isClockwise: true)
        addAnimation(radius: 100, isClockwise: true)
        addAnimation(radius: 50, isClockwise: true)
    }

    func addStar() {
        let squareView = UIImageView(image: UIImage(named: "star")!)
        // whatever the value of origin for squareView will not affect the animation
        squareView.frame = CGRect(origin: view.center, size: .init(width: 40, height: 40))
        squareView.backgroundColor = .clear
        view.addSubview(squareView)
    }

    func addAnimation(radius: CGFloat, isClockwise: Bool) {
        func decideDuration() -> CFTimeInterval {
            switch radius {
            case 0...51:
              return 4
            case 52...101:
                return 5
            case 102...151:
                return 8
            default:
              return 9
            }
        }

        let circlePath = UIBezierPath(arcCenter: view.center, radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: isClockwise)

        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = decideDuration()
        animation.repeatCount = MAXFLOAT
        animation.path = circlePath.cgPath

        let squareView = UIImageView(image: UIImage(named: "star")!)
        // whatever the value of origin for squareView will not affect the animation
        squareView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        squareView.backgroundColor = .clear

        view.addSubview(squareView)
        // You can also pass any unique string value for key
        squareView.layer.add(animation, forKey: nil)

        // circleLayer is only used to locate the circle animation path
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(circleLayer)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
