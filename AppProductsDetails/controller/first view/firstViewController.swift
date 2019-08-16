//
//  ViewController.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/12/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit
import SDWebImage

class firstViewController: UITableViewController {
    
    //MARK: - query data
    var searchItem: String?
    var pageItem: Int = 1
    
    var listOfProducts = [productDetail](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var images = [UIImage]()
    var url = [String]()
    
    //image index for cells
//    var currentProduct = 0
//    var numberOfProducts = 0
    
    func distributeImage() {
        // take first url
        for product in listOfProducts {
            if !(product.images!.isEmpty) {
                url.append((product.images?.first?.url!)!)
            } else {
                url.append("")
            }
        }
        
    }

//    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchBar: UISearchBar!
    //MARK: - ViewDidLoad and viewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.keyboardDismissMode = .onDrag
//        tableView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.frame.size.height = 60
    }
    
    //MARK: - Table view datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let data = listOfProducts[indexPath.row]
        
        DispatchQueue.main.async {
            
            cell.nameOfProduct.text = data.name
            let price = (String)(data.price.sellPrice ?? 0)
            cell.price.text = (price != "0" ? "\(price) vnd" : "No information about price")
            
            //load image
            let imageRs = UIImage(named: "image_unavailable")!
            let product = self.listOfProducts[indexPath.row]
            DispatchQueue.main.async {
                if let imageArray = product.images {
                    if imageArray.count > 0 {
                        if let url = URL(string: imageArray[0].url!) {
                            cell.imageProduct.sd_setImage(with: url)
                        } else {
                            cell.imageProduct.image = imageRs
                        }
                    } else {
                        cell.imageProduct.image = imageRs
                    }
                    
                }
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailView", sender: self)
        tableView.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let vc = segue.destination as! secondTableViewController
                vc.product = listOfProducts[indexPath.row]
                vc.querryString = searchItem
            }
        }
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            pageItem += 1
            loadData(page: pageItem, limit: 10, query: searchItem ?? "")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfProducts.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

//MARK: - Search bar
extension firstViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        listOfProducts = [productDetail]()
        searchBar.setShowsCancelButton(false, animated: true)
        guard let searchBarText = searchBar.text else {
            return
        }
        navigationItem.title = searchBar.text
        searchItem = searchBar.text
        
        pageItem = 1
        
        DispatchQueue.main.async {
            self.loadData(page: self.pageItem, limit: 10, query: searchBarText)
        }
        
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //MARK: - Load data from api
    func loadData(page: Int, limit: Int, query: String) {
        let productsRequest = productRequest(page: page,limit: limit, query: query)
        productsRequest.getProduct { [weak self] rs in
            switch rs {
            case .failure(let error):
                print(error)
            case .success(let products):
                for value in products {
                    self?.listOfProducts.append(value)
                }
                self!.distributeImage()
            }
        }
    }
    
}
