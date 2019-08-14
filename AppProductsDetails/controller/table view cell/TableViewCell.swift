//
//  TableViewCell.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/12/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameOfProduct: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
