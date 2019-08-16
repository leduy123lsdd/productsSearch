//
//  CollectionViewCell.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/15/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image.layer.cornerRadius = 6
    }

}
