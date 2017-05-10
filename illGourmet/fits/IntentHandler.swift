//
//  IntentHandler.swift
//  fits
//
//  Created by Vibes on 4/11/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Intents
import PassKit

class IntentHandler: INExtension, INRequestRideIntentHandling {
    let paymentHandler = PaymentHandler()
    
    func handle(requestRide intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        var response = INRequestRideIntentResponse(code: .success, userActivity: nil)
        let rideStatus = INRideStatus()
        
        // Apple Pay Payment
        paymentHandler.startPayment() { (success) in
            if success {
                var driverName = PersonNameComponents()
                driverName.givenName = "Johnny"
                driverName.familyName = "A"
                let driverHandle = INPersonHandle(value: "john-appleseed@mac.com", type: .emailAddress)
                
                rideStatus.driver = INRideDriver(personHandle: driverHandle, nameComponents: driverName, displayName: nil, image: nil, contactIdentifier: nil, customIdentifier: nil)
            } else {
                response = INRequestRideIntentResponse(code: .failure, userActivity: nil)
            }
            completion(response)
        }
    }
    
    func resolveUsesApplePayForPayment(forRequestRide intent: INRequestRideIntent, with completion: (INBooleanResolutionResult) -> Void) {
        completion(INBooleanResolutionResult.success(with: true))
    }
    
}
