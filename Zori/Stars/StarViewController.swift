//
//  StarViewController.swift
//  Zori
//
//  Created by Oleksandr on 9/9/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import UIKit
import SDWebImage

class StarViewController: UIViewController, Alertable {
    var star: Star!
    var info: [(String, String?)] = []
    
    @IBOutlet private weak var infoTextView: UITextView!
    @IBOutlet private weak var pointButton: UIButton!
    @IBOutlet private weak var infoTableView: UITableView!
    
    @IBOutlet private weak var starImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        self.title = star.name_r
        infoTextView.text = star.description_r
        
        let fullName = "\(star.name_r ?? "") (\(star.name ?? ""))"
        info.append(("Name", fullName))
        
        let fullConst = "\(star.constellation_r ?? "") (\(star.constellation ?? "" ))"
        info.append(("Constellation", fullConst))
        
        let positionInTime = "\(star.hours):\(star.minutes):\(star.seconds)"
        info.append(("'HH':'mm':'ss'", positionInTime))

        let position = "\(star.deg)° \(star.min)′ \(star.sec)″"
        info.append(("DMS", position))
        
        info.append(("Sign", star.sign))
        info.append(("Vmag", "\(star.vmag)"))
        info.append(("GLON", "\(star.gLON)"))
        info.append(("GLAT", "\(star.gLAT)"))
        
        infoTableView.reloadData()
        guard let img =  star.img, let url = URL(string: img) else { return }
        starImageView.sd_setImage(with: url)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        infoTextView.setContentOffset(CGPoint.zero, animated: true)
    }

    @IBAction private func pointAction(_ sender: UIButton) {
        let pair = Converter().point(to: star)
        let res = "Azimuth \(pair.0.degrees)º\nAltitude: \(pair.1.degrees)º"
        showAlert(res)
        BLEConnector.shared.send(azimuth: pair.0, decline: pair.1)
    }
    
    
}

extension StarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
        let item = info[indexPath.row]
        cell.textLabel?.text = item.0
        cell.detailTextLabel?.text = item.1
        return cell
    }
    
}
