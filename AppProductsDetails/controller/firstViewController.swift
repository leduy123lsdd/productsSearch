//
//  ViewController.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/12/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit

class firstViewController: UITableViewController {
    
    var imageData = [ Int: [imageDetail] ]()
    var images = [UIImage]()
    
    //MARK: - Data stored
    var listOfProducts = [productDetail](){
        didSet {
            DispatchQueue.main.async {
                self.distributeImage()
                self.tableView.reloadData()
            }
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    var index = 0
    
    func distributeImage() {
        
        for data in listOfProducts {
            //Lay ra cac mang chua url
            imageData[index] = data.images
            index += 1
        }
        index -= 1
        //load throw singer image array
        for key in 0...index {
            //get image array by key
            if let imagesArray = imageData[key] {
                //check if image array is empty
                if imagesArray.isEmpty {
                    images.append(UIImage(named: "image_unavailable")!)
                }
                else {
                    if let url = URL(string: imagesArray[0].url!) {
//                        images[key] = loadImage(url: url)
                        images.append(loadImage(url: url))
                    }
                    
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.keyboardDismissMode = .onDrag
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
            
//            if let imageUrl = data.images {
//                if imageUrl.isEmpty {
//                    cell.imageProduct.image = UIImage(named: "image_unavailable")
//                } else {
//                    if let _url = URL(string: (imageUrl[0].url)!) {
//                        cell.imageProduct.loadImage(url: _url)
//                    }
//                    else {
//                        cell.imageProduct.image = UIImage(named: "image_unavailable")
//                    }
//                }
//            }
            
            print(self.images.count)
            cell.imageProduct.image = self.images[indexPath.row]
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
        searchBar.setShowsCancelButton(true, animated: true)

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        guard let searchBarText = searchBar.text else {
            return
        }
        
        navigationItem.title = searchBar.text
        
        DispatchQueue.main.async {
            let productsRequest = productRequest(page: 1, limit: 10, query: searchBarText)
            productsRequest.getProduct { [weak self] rs in
                switch rs {
                case .failure(let error):
                    print(error)
                    return
                case .success(let products):
                    self?.listOfProducts += products
                    return
                }
            }
        }
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

//MARK: - load image by url
//extension UIImageView {
//    func loadImage(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                DispatchQueue.main.async {
//                    if let image = UIImage(data: data) {
//                        self?.image = image
//                    } else {
//                        self?.image = UIImage(named: "image_unavailable")
//                    }
//                }
//            }
//        }
//    }
//}
extension firstViewController {
    func loadImage(url: URL) -> UIImage {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return UIImage(named: "image_unavailable")!
    }
}
