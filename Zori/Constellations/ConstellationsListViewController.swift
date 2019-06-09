//
//  ConstellationsListViewController.swift
//  Zori
//
//  Created by Oleksandr on 9/9/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import UIKit
import Moya
import PromiseKit
import SDWebImage

class ConstellationsListViewController: UIViewController, Alertable {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerImageView: UIImageView!
    
    private var cons: [Constellation] = []
    
    let service: ConstellationService = ConstellationServiceImplementation(api: MoyaProvider<ConstellationAPI>())
    let imageView = UIImageView(image: #imageLiteral(resourceName: "header"))

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        service.getList().done { (list) in
            self.cons = list
            self.tableView.reloadData()
        }.catch { (error) in
            self.showError(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let starDetails = segue.destination as? StarViewController, let starSection = tableView.indexPathForSelectedRow?.section, let starRow = tableView.indexPathForSelectedRow?.row {
            starDetails.star = cons[starSection].stars?.allObjects[starRow] as! Star
        }
    }
}

extension ConstellationsListViewController: UITableViewDelegate {}

extension ConstellationsListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

extension ConstellationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //HeaderCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        let constellation = cons[section]
        cell?.textLabel?.text = constellation.name_r
        cell?.detailTextLabel?.text = constellation.name
        
        if let str = constellation.img, let url = URL(string: str) {
            cell?.imageView?.sd_setImage(with: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cons[section].stars?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StarCell", for: indexPath)
        let constellation = cons[indexPath.section]
        let star = (constellation.stars?.allObjects as! [Star])[indexPath.row]
        cell.textLabel?.text = star.name_r
        cell.detailTextLabel?.text = star.description_r
        let randNumber = String(arc4random_uniform(5)+1)
        let randomPlaceholder = "star_"+randNumber
        cell.imageView?.image = UIImage(named: randomPlaceholder)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cons[section].name_r
    }
}

