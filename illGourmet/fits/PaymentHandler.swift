//
//  PaymentHandler.swift
//  fits
//
//  Created by Vibes on 4/11/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

@available(iOS 10.0, *)
class PaymentHandler: NSObject {
    
    static let supportedNetworks: [PKPaymentNetwork] = [
        .amex,
        .masterCard,
        .visa
    ]
    
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?
    
    class func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (PKPaymentAuthorizationController.canMakePayments(),
                PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks));
    }
    
    func startPayment(completion: @escaping PaymentCompletionHandler) {
        
        let fare = PKPaymentSummaryItem(label: "Minimum Fare", amount: NSDecimalNumber(string: "0.00"), type: .final)
        let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "0.00"), type: .final)
        let total = PKPaymentSummaryItem(label: "Emporium", amount: NSDecimalNumber(string: "0.01"), type: .pending)
        
        paymentSummaryItems = [fare, tax, total];
        completionHandler = completion
        
        // Create our payment request
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = "merchant.vibes.illgourmet"
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.requiredShippingAddressFields = [.phone, .email, .postalAddress]
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
        
        // Display our payment request
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                NSLog("Presented payment controller")
            } else {
                NSLog("Failed to present payment controller")
                self.completionHandler!(false)
            }
        })
    }
}

/*
 PKPaymentAuthorizationControllerDelegate conformance.
 */
@available(iOS 10.0, *)
extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        // Perform some very basic validation on the provided contact information
        if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.phoneNumber == nil {
            paymentStatus = .invalidShippingContact
        } else {
            // Here you would send the payment token to your server or payment provider to process
            // Once processed, return an appropriate status in the completion handler (success, failure, etc)
            paymentStatus = .success
        }
        
        completion(paymentStatus)
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectPaymentMethod paymentMethod: PKPaymentMethod, completion: @escaping ([PKPaymentSummaryItem]) -> Void) {
        // The didSelectPaymentMethod delegate method allows you to make changes when the user updates their payment card
        // Here we're applying a $2 discount when a debit card is selected
        if paymentMethod.type == .debit {
            var discountedSummaryItems = paymentSummaryItems
            let discount = PKPaymentSummaryItem(label: "Debit Card Discount", amount: NSDecimalNumber(string: "-0.01"))
            discountedSummaryItems.insert(discount, at: paymentSummaryItems.count - 1)
            if let total = paymentSummaryItems.last {
                total.amount = total.amount.subtracting(NSDecimalNumber(string: "0.01"))
            }
            completion(discountedSummaryItems)
        } else {
            completion(paymentSummaryItems)
        }
    }
}
