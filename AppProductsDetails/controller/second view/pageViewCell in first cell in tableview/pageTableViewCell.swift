//
//  pageTableViewCell.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/15/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit
import SDWebImage

class pageTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    // get data
    var urlString = [imageDetail]()
    
    let width = UIScreen.main.bounds.width
    var timerChangerImage: Timer?
    
    var scrollItemIndex = 0
    var scrollFoward = false
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        pageControl.hidesForSinglePage = true
        pageControl.endEditing(true)
        
        
        timerChangerImage = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
    }
    
    
    
    @objc func runTimedCode() {
        if urlString.count == 0 {
            return
        }
        
        if scrollItemIndex == urlString.count-1 {
            scrollFoward = false
        } else if scrollItemIndex == 0 {
            scrollFoward = true
        }
        
        if scrollFoward {
            collectionView.scrollToNextItem()
            scrollItemIndex += 1
        } else {
            collectionView.scrollToPreviousItem()
            scrollItemIndex -= 1
        }
        pageControl.currentPage = scrollItemIndex
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - collection view delegate and datasource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        if urlString.count > 0 {
            if let _url = URL(string: urlString[indexPath.row].url!) {
                cell.image.sd_setImage(with: _url)
            }
        } else {
            cell.image.image = UIImage(named: "image_unavailable")
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        scrollItemIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = urlString.count
        if urlString.count == 0 {
            return 1
        }
        return urlString.count
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
}

extension pageTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: width - 12, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    
    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
