//
//  ArticlesTableViewController.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import UIKit
import Moya
import PromiseKit

class ArticlesTableViewController: UITableViewController, Alertable {
    private var articles: [Article] = []
    
    let service: ArticleService = ArticleServiceImplementation(api: MoyaProvider<ArticleAPI>())
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        service.getList().done { (list) in
            self.articles = list
            self.tableView.reloadData()
        }.catch { (error) in
            self.showError(error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)

        let article = articles[indexPath.row]
        cell.textLabel?.text = article.title
        cell.detailTextLabel?.text = article.body

        return cell
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let full = segue.destination as? FullArticleViewController {
            full.article = articles[tableView.indexPathForSelectedRow!.row]
        }
    }
    

}
