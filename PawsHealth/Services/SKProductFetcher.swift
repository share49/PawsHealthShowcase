//
//  SKProductFetcher.swift
//  Hoowie
//
//  Created by Roger Pintó Diaz on 11/13/19.
//  Copyright © 2019 Roger Pintó Diaz. All rights reserved.
//

import Foundation
import StoreKit

final class SKProductFetcher: NSObject {
    
    private var callback: ((_ product: [SKProduct]) -> ())? = nil
    
    func getProduct(_ id: String, completion: @escaping (_ product: [SKProduct]) -> ()) {
        callback = completion
        requestProduct(id)
    }
    
    func getProducts(_ ids: Set<String>, completion: @escaping (_ product: [SKProduct]) -> ()) {
        callback = completion
        requestProducts(ids)
    }
    
    private func requestProduct(_ id: String) {
        requestProducts([id])
    }
    
    private func requestProducts(_ ids: Set<String>) {
        guard SKPaymentQueue.canMakePayments() else {
            MyLogE("SKProductFetcher: Cannot perform In App Purchases")
            return
        }
        
        let productRequest = SKProductsRequest(productIdentifiers: ids)
        productRequest.delegate = self
        productRequest.start()
    }
}

// MARK: - SKProductsRequestDelegate
extension SKProductFetcher: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var productsArray = [SKProduct]()
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
        } else {
            MyLogI("SKProductFetcher: There are no products")
        }
        
        callback?(productsArray)
        
        if response.invalidProductIdentifiers.count != 0 {
            MyLogE("SKProductFetcher: invalidProductIdentifiers: \(response.invalidProductIdentifiers.description)")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        MyLogE("SKProductFetcher: Request failed. \(error)")
    }
}
