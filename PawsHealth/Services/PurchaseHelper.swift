//
//  PurchaseHelper.swift
//  PawsHealth
//
//  Created by Roger Pintó Diaz on 11/16/19.
//  Copyright © 2019 Roger Pintó Diaz. All rights reserved.
//

import Foundation
import StoreKit

final class PurchaseHelper: NSObject {

    static let instance = PurchaseHelper()

    // MARK: - Properties
    private var purchaseCallback: ((_ success: Bool, _ error: NSError?) -> ())? = nil

    // MARK: - Support methods
    func purchaseProduct(_ product: SKProduct, withCompletion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        purchaseCallback = withCompletion
        purchase(product)
    }

    private func purchase(_ product: SKProduct) {
        MyLogI("PurchaseHelper: About to purchase: \(product.localizedDescription)")

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
}

// MARK: - SKPaymentTransactionObserver
extension PurchaseHelper: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        MyLogI("PurchaseHelper: PaymentQueue: updatedTransactions: self: \(self)")
        MyLogI("PurchaseHelper: Transactions: \(transactions)")

        var succeeded = false
        var failed = false
        var lastError: NSError? = nil

        for transaction in transactions {
            switch transaction.transactionState {
                case .purchasing:
                    MyLogI("PurchaseHelper: Transaction state -> Purchasing")

                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction)
                    MyLogI("PurchaseHelper: Transaction state -> Purchased")
                    succeeded = true

                case .failed: /// Called when the transaction does not finish
                    failed = true
                    MyLogI("PurchaseHelper: Transaction state -> Failed")

                    if let error = transaction.error as NSError? {
                        if error.code == SKError.paymentCancelled.rawValue {
                            MyLogI("PurchaseHelper: Transaction state -> Failed: User cancelled the payment")
                        } else {
                            lastError = error
                        }
                    }
                    SKPaymentQueue.default().finishTransaction(transaction)

                default:
                    MyLogI("PurchaseHelper: \(transaction.transactionState)")
            }
        }

        if succeeded {
            purchaseCallback?(true, nil)
        }

        if failed {
            purchaseCallback?(false, lastError)
        }
    }
}
