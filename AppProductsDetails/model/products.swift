//
//  sfadfdf.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/12/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import Foundation

// price, image, displayName
struct priceInfo: Decodable {
    var sellPrice: Int?
}

struct imageDetail: Decodable {
    var url: String?
}


///////////////////////////
struct productDetail: Decodable {
    var name: String?
    var price: priceInfo
    var images: [imageDetail]?
}

///////////////////////////
struct products:Decodable {
    var products : [productDetail]
}

///////////////////////
struct productResult: Decodable {
    var result: products
}
