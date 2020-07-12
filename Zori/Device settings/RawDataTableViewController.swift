//
//  RawDataTableViewController.swift
//  Zori
//
//  Created by Oleksandr on 02.02.2020.
//  Copyright © 2020 ekreative. All rights reserved.
//

import UIKit
import SVProgressHUD

class RawDataTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    let session = URLSession(configuration: URLSessionConfiguration.default)
    var getTask = URLSessionTask()

    var results: [String: String] = [:] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var keys: [String] {
        Array(results.keys).sorted()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
        let key = keys[indexPath.row]
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = results[key]
        return cell
    }
}

extension RawDataTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.resignFirstResponder()
        } else {
            // Fallback on earlier versions
        }
        guard let search = searchBar.text else { return }
        guard let url = URL(string: "http://zori.uw-t.com/catalog-json/\(search)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        SVProgressHUD.setStatus("Searching \(search)")
        getTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let resData = data else { return }
            let mapped = try? JSONDecoder().decode(Results.self, from: resData)
            if let first = mapped?.nodes.first {
                debugPrint(first.node)
                self.results = first.node
            }
            SVProgressHUD.dismiss()
        })


        getTask.resume()
        debugPrint(searchBar.text ?? "??")
    }
}

// MARK: - Welcome
struct Results: Codable {
    let nodes: [Node]
    let pager: Pager
}

// MARK: - Node
struct Node: Codable {
    let node: [String: String]
}

// MARK: - Pager
struct Pager: Codable {
    let pages, page, count, limit: Int
}
