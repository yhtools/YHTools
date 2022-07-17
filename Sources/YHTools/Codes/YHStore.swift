//
//  YHStore.swift
//  
//
//  Created by 莹 on 2022/7/7.
//

import Foundation
import StoreKit

public protocol YHStoreDelegate: AnyObject {
    
    func storeProducts(_ products:[SKProduct]?,error:Error?)
    
    func storePurchaseDidSucceed(transaction:SKPaymentTransaction)
    
    func storeRestoreDidSucceed(transaction:SKPaymentTransaction)
    
    func storeError(_ error: Error?)
    
    func storeNoRestorablePurchases()
}

public class YHStore: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    public static let shared = YHStore()
    private weak var delegate:YHStoreDelegate?
    private var hasRestorablePurchases = false
    
    private override init() {}
    
    public func start(delegate:YHStoreDelegate?) {
        
        self.delegate = delegate
        SKPaymentQueue.default().add(self)
    }
    
    public func payment(product:SKProduct) {
        
        SKPaymentQueue.default().add(SKMutablePayment(product: product))
    }
    
    public func restore() {
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - SKProductsRequest
    
    public func getProducts(_ productIds:Set<String>) {
        
        let request = SKProductsRequest(productIdentifiers: productIds)
        request.delegate = self
        request.start()
    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        DispatchQueue.main.async {
            [weak self] in
            
            self?.delegate?.storeProducts(response.products, error: nil)
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        
        DispatchQueue.main.async {
            [weak self] in
            
            self?.delegate?.storeProducts(nil, error: error)
        }
    }
    
    // MARK: - SKPaymentTransactionObserver
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        DispatchQueue.main.async {
            [weak self] in
            
            transactions.forEach({
                transaction in
                
                switch transaction.transactionState {
                case .purchasing: break
                case .deferred: break
                case .purchased:
                    self?.handlePurchased(transaction: transaction)
                case .failed:
                    self?.handleFailed(transaction: transaction)
                case .restored:
                    self?.handleRestored(transaction: transaction)
                default: break
                }
            })
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
        DispatchQueue.main.async {
            [weak self] in
            
            self?.delegate?.storeError(error)
        }
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
            [self] in
            
            if !hasRestorablePurchases {
            
                delegate?.storeNoRestorablePurchases()
            }
        })
    }
    
    private func handlePurchased(transaction:SKPaymentTransaction) {
        
        delegate?.storePurchaseDidSucceed(transaction: transaction)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func handleFailed(transaction:SKPaymentTransaction) {
        
        delegate?.storeError(transaction.error)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func handleRestored(transaction:SKPaymentTransaction) {
        
        hasRestorablePurchases = true
        delegate?.storeRestoreDidSucceed(transaction: transaction)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
