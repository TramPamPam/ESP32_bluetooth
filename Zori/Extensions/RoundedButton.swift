//
//  RoundedButton.swift
//  Zori
//
//  Created by Oleksandr on 6/9/19.
//  Copyright © 2019 ekreative. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    @IBInspectable var radius: CGFloat = 5.0
    @IBInspectable var border: CGFloat = 2.0

    var corners: UIRectCorner? = .allCorners

    override func layoutSubviews() {
        super.layoutSubviews()
        round()
    }

    func round() {
        guard let corners = corners else {
            return
        }
        applyMask(for: corners, radius: radius)
    }

    private func applyMask(for corners: UIRectCorner, radius: CGFloat) {
        let rect = bounds.insetBy(dx: 0, dy: 0)
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
        if border > 0 {
            layer.borderWidth = border
            layer.borderColor = tintColor.cgColor
        }

    }
}
