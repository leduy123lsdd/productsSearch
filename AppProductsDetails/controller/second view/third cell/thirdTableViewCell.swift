//
//  thirdTableViewCell.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/16/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit

class thirdTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var historyQuerry: String?
    
    var products: productDetail? {
        didSet {
            loadData(page: 1, limit: 10, query: products?.brand.name ?? "")
        }
    }
    
    var suggestList = [productDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var url = [String]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        collectionView.register(UINib(nibName: "suggestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "suggestCell")
    }
    
    //MARK: - collectionView deletegate and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestCell", for: indexPath) as! suggestCollectionViewCell
//        cell.price.text = String(products[indexPath.row].price.sellPrice ?? 0)
//        cell.nameProduct.text = products[indexPath.row].name ?? "Unknow"
        let data = suggestList[indexPath.row]
        
        cell.price.text = (String)(data.price.sellPrice ?? 0)
        cell.nameProduct.text = data.name
        
        DispatchQueue.main.async {
            if let imageArray = self.products?.images {
                if imageArray.count > 0 {
                    if let URL = URL(string: self.url[indexPath.row]) {
                        cell.imageView.sd_setImage(with: URL)
                    } else {
                        cell.imageView.image = UIImage(named: "image_unavailable")
                    }
                } else {
                    cell.imageView.image = UIImage(named: "image_unavailable")
                }
            }
            
            
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension thirdTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 50, height: 100)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

//MARK: - Load data
extension thirdTableViewCell {
    func loadData(page: Int, limit: Int, query: String) {
        let productsRequest = productRequest(page: page,limit: limit, query: query)
        productsRequest.getProduct { [weak self] rs in
            switch rs {
            case .failure(let error):
                print(error)
            case .success(let products):
                for value in products {
                    self?.suggestList.append(value)
                }
                self!.distributeImage()
            }
        }
    }
    
    func distributeImage() {
        // take first url
        for product in suggestList {
            if !(product.images!.isEmpty) {
                url.append((product.images?.first?.url!)!)
            } else {
                url.append("")
            }
        }
        
    }
}
