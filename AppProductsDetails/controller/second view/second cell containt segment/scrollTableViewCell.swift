//
//  scrollTableViewCell.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/19/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit

class scrollTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var name = "No information"
    var price = 0
    var descriptionProduct = "No information"
    var brand = "No information"
    var productType = "No information"
    var information = ""
    
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
            
            segment.selectedSegmentIndex = 0
            segmentAction(segment)
            segment.reloadInputViews()
//            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.borderWidth = 0.8
        collectionView.layer.borderColor = UIColor.purple.cgColor
        collectionView.layer.cornerRadius = 6
        
        collectionView.register(UINib(nibName: "scrollCollectionCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        segment.selectedSegmentIndex = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {

        switch segment.selectedSegmentIndex {
        case 0:
            var priceString = ""
            
            let _price = price as NSNumber
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "vi_VN")
            
            priceString = formatter.string(from: _price)!
            
            information = "Price: \(priceString) \nBrand: \(brand)"
        case 1:
            information = "Description: \(descriptionProduct) \nName: \(name)\nType: \(productType)"
        default:
            return
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! scrollCollectionCell
        
        cell.textField.text = information
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        segment.selectedSegmentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}

extension scrollTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
