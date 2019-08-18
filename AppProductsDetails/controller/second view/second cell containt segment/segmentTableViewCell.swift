//
//  segmentTableViewCell.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/15/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit

class segmentTableViewCell: UITableViewCell {
    
    var name = "No information"
    var price = 0
    var descriptionProduct = "No information"
    var brand = "No information"
    var productType = "No information"
    
    var productDetail : productDetail? {
        didSet {
            if let name = productDetail?.name {
                self.name = name
            }
            if let price = productDetail?.price.sellPrice {
                self.price = price
            }
            
            if let descrip = productDetail?.seoInfo.description {
                self.descriptionProduct = descrip
            }
            if let brand = productDetail?.brand.name {
                self.brand = brand
            }
            if let type = productDetail?.productType.name {
                self.productType = type
            }
            
            segmentControl.selectedSegmentIndex = 0
            segmentAction(segmentControl)
            segmentControl.reloadInputViews()
        }
    }

    @IBOutlet weak var textfieldControl: UITextView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let priceString = price == 0 ? "No information" : String(price/1000) + ".000"
            textfieldControl.text = "Price: \(priceString) VNĐ \nBrand: \(brand)"
        case 1:
            textfieldControl.text = "Description: \(descriptionProduct) \nName: \(name)"
        case 2:
            textfieldControl.text = "Type: \(productType)"
        default:
            return
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        segmentControl.selectedSegmentIndex = 0
        segmentAction(segmentControl)
        segmentControl.reloadInputViews()
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
