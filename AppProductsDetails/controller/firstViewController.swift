//
//  ViewController.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/12/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit

class firstViewController: UITableViewController {
    
    var imageData = [[UIImage]]()
    //MARK: - Data stored
    var listOfProducts = [productDetail](){
        didSet {
            DispatchQueue.main.async {
//                if let imageUrl = data.images {
//                    if imageUrl.isEmpty {
//                        cell.imageProduct.image = UIImage(named: "image_unavailable")
//                    } else {
//                        let _url = URL(string: imageUrl[0].url!)
//                        cell.imageProduct.loadImage(url: _url!)
//                    }
//                }
//                for data in self.listOfProducts {
//
//                    if let imageUrl = data.images {
//                        if imageUrl.isEmpty {
//                            return
//                        } else {
//                            let _url = URL(string: imageUrl[0].url!)
//
//                        }
//                    }
//                }
                self.tableView.reloadData()
            }
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.keyboardDismissMode = .onDrag
//        searchBar.showsCancelButton = true
//        searchBar.setShowsCancelButton(true, animated: true)
        let hideKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tableView.addGestureRecognizer(hideKeyboard)
    }
    
    @objc func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.frame.size.height = 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let data = listOfProducts[indexPath.row]
        
        DispatchQueue.main.async {
            cell.nameOfProduct.text = data.name
            
            let price = (String)(data.price.sellPrice ?? 0)
            cell.price.text = (price != "0" ? "\(price) vnd" : "No information about price")
            
            if let imageUrl = data.images {
                if imageUrl.isEmpty {
                    cell.imageProduct.image = UIImage(named: "image_unavailable")
                } else {
                    if let _url = URL(string: (imageUrl[0].url)!) {
                        cell.imageProduct.loadImage(url: _url)
                    }
                    else {
                        cell.imageProduct.image = UIImage(named: "image_unavailable")
                    }
                }
            }
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let vc = segue.destination as! secondViewController
//                vc.image = imageData[indexPath.row]
            }
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
//        searchBar.showsCancelButton = true
        searchBar.setShowsCancelButton(true, animated: true)

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
        searchBar.setShowsCancelButton(false, animated: true)
        guard let searchBarText = searchBar.text else {
            return
        }
        
        navigationItem.title = searchBar.text
        
        DispatchQueue.main.async {
            let productsRequest = productRequest(page: 1, limit: 10, query: searchBarText)
            productsRequest.getProduct { [weak self] rs in
                switch rs {
                case .failure(let error): print(error)
                case .success(let products): self?.listOfProducts = products
                }
            }
        }
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
//        searchBar.showsCancelButton = false
        searchBar.setShowsCancelButton(false, animated: true)
        
        

    }
}

//MARK: - load image by url
extension UIImageView {
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self?.image = image
                    } else {
                        self?.image = UIImage(named: "image_unavailable")
                    }
                }
            }
        }
    }
}
