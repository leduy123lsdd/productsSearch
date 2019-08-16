//
//  suggestCollectionViewCell.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/16/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit

class suggestCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameProduct: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.layer.cornerRadius = 6
    }

}
