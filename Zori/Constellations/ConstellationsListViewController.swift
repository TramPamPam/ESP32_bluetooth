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

class ConstellationsListViewController: UIViewController, Alertable {

    @IBOutlet private weak var tableView: UITableView!
    
    private var cons: [Constellation] = []
    
    let service: ConstellationService = ConstellationServiceImplementation(api: MoyaProvider<ConstellationAPI>())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 64
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

extension ConstellationsListViewController: UITableViewDataSource {
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cons[section].name_r
    }
}

