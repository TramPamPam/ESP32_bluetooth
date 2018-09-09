//
//  StarListViewController.swift
//  Zori
//
//  Created by Oleksandr on 9/9/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import UIKit
import Moya
import PromiseKit

class StarListViewController: UIViewController, Alertable {

    @IBOutlet private weak var tableView: UITableView!
    
    private var stars: [Star] = []
    
    let service: StarService = StarServiceImplementation(api: MoyaProvider<ZoriAPI>())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 64
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        service.getList().done { (list) in
            self.stars = list
            self.tableView.reloadData()
        }.catch { (error) in
            self.showError(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let starDetails = segue.destination as? StarViewController, let starRow = tableView.indexPathForSelectedRow?.row {
            starDetails.star = stars[starRow]
        }
    }
}

extension StarListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StarCell", for: indexPath)
        
        let star = stars[indexPath.row]
        cell.textLabel?.text = star.name_r
        cell.detailTextLabel?.text = star.description_r
        
        return cell
    }
}

