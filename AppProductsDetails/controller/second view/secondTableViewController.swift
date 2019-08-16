//
//  secondTableViewTableViewController.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/15/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit

class secondTableViewController: UITableViewController {
    
    var product: productDetail?
    var querryString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "pageTableViewCell", bundle: nil), forCellReuseIdentifier: "firtCell")
        tableView.register(UINib(nibName: "segmentTableViewCell", bundle: nil), forCellReuseIdentifier: "secondCell")
        tableView.register(UINib(nibName: "thirdTableViewCell", bundle: nil), forCellReuseIdentifier: "thirdCell")
        navigationItem.title = querryString!
        tableView.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell_1 : pageTableViewCell
        var cell_2 : segmentTableViewCell
        var cell_3 : thirdTableViewCell
        let cell_4 = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell_1 = tableView.dequeueReusableCell(withIdentifier: "firtCell", for: indexPath) as! pageTableViewCell
            cell_1.urlString = (product?.images!)!
            return cell_1
        case 1:
            cell_2 = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as! segmentTableViewCell
            cell_2.productDetail = product
            return cell_2
        case 2 :
            cell_3 = tableView.dequeueReusableCell(withIdentifier: "thirdCell", for: indexPath) as! thirdTableViewCell
            cell_3.products = product
            cell_3.historyQuerry = querryString
            return cell_3
        default:
            return cell_4
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 300
        }
        if indexPath.row == 1 {
            return 150.0
        }
        if indexPath.row == 2 {
            return 200.0
        }
        return 0.0
    }
    

}


