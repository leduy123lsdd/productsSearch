//
//  productRequest.swift
//  AppProductsDetails
//
//  Created by Lê Duy on 8/12/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import Foundation
import SVProgressHUD

enum getProductError: Error {
    case NoDataAvailable
    case CanNotProcessData
}

class productRequest {
    let resourceURL: URL
    
    init(page: Int, limit: Int, query: String) {
        let resourceString = "https://listing-stg.services.teko.vn/api/search/?channel=pv_online&visitorId=&q=\(query)&terminal=CP01&_page=\(page)&_limit=\(limit)"
        let defaultString = "https://listing-stg.services.teko.vn/api/search/?channel=pv_online&visitorId=&q=home&terminal=CP01&_page=\(page)&_limit=\(limit)"
        
        if let resourceURL = URL(string: resourceString) {
            self.resourceURL = resourceURL
        } else {
            let defaultResource = URL(string: defaultString)
            self.resourceURL = defaultResource!
            
        }
        
    }
    
    func getProduct(completion: @escaping(Result<[productDetail], getProductError>) -> Void) {
        SVProgressHUD.show()
        let dataTark = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            
            guard let jsonData = data else {
                completion(.failure(.NoDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let productsResult = try decoder.decode(productResult.self, from: jsonData)
                let productDetails = productsResult.result.products
                
                completion(.success(productDetails))
            } catch {
                completion(.failure(.CanNotProcessData))
            }
        }
        
        dataTark.resume()
        SVProgressHUD.dismiss()
    }
}
