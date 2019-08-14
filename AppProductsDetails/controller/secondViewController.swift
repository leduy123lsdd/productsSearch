//
//  secondViewController.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/12/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {
    var image: String?
    
    @IBOutlet weak var imageContent: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageContent.image = UIImage(named: image ?? "error")
    }

}
