//
//  homeTableViewController.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/16/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit

class homeTableViewController: UITableViewController {
    
    let bestSellProducts = ["https://img1.phongvu.vn/media/catalog/product/3/2/32w610f_4.jpg","https://img1.phongvu.vn/media/catalog/product/3/2/32w610f_7.jpg", "https://img1.phongvu.vn/media/catalog/product/i/n/internet_tivi_32_inch_sony_kdl-32w610f-4.jpg", "https://img1.phongvu.vn/media/catalog/product/i/n/internet_tivi_32_inch_sony_kdl-32w610f-3.jpg"
    ]
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "pageTableViewCell", bundle: nil), forCellReuseIdentifier: "cell0")
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: for first cell, fetach url of best sell products. 
        var data = [imageDetail]()
        for url in bestSellProducts {
            var new = imageDetail()
            new.url = url
            data.append(new)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! pageTableViewCell
        cell.urlString = data
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Bán chạy."
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    
    var searchItem: String?
}

extension homeTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        listOfProducts = [productDetail]()
//        searchBar.setShowsCancelButton(false, animated: true)
//        guard let searchBarText = searchBar.text else {
//            return
//        }
//        navigationItem.title = searchBar.text
//        searchItem = searchBar.text
//
//        pageItem = 1
//
//        DispatchQueue.main.async {
//            self.loadData(page: self.pageItem, limit: 10, query: searchBarText)
//        }
//
//        searchBar.endEditing(true)
        guard let searchBarText = searchBar.text else {return}
        navigationItem.title = searchBarText
        searchItem = searchBarText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSearch" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let vc = segue.destination as! firstViewController
                
                vc.searchItem = searchItem
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "resultSearch", sender: self)
    }
}
