//
//  CharacteristicTableViewCell.swift
//  Zori
//
//  Created by Oleksandr on 20.09.2020.
//  Copyright © 2020 zori. All rights reserved.
//

import UIKit

final class CharacteristicTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CharacteristicTableViewCell"

    static let height: CGFloat = 88

    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet private weak var readButton: UIButton!

    @IBOutlet private weak var writeButton: UIButton!



    var readAction: (() -> Void)?
    var writeAction: (() -> Void)?

    func fill(title: String,
              subtitle: String,
              canRead: Bool,
              readAction: @escaping (() -> Void),
              canWrite: Bool,
              writeAction: @escaping (() -> Void)) {

        titleLabel.text = title

        subtitleLabel.text = subtitle

        self.readAction = readAction

        self.writeAction = writeAction

        readButton.isHidden = !canRead

        writeButton.isHidden = !canWrite
    }

    @IBAction private func tapOnRead(_ sender: Any) {
        readAction?()
    }

    @IBAction private func tapOnWrite(_ sender: Any) {
        writeAction?()
    }

}
