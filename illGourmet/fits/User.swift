//
//  User.swift
//  fits
//
//  Created by Vibes on 4/12/17.
//  Copyright © 2017 PZRT. All rights reserved.
//


import Foundation

class User {
 
    static let shared: User = User()
    
    var myLooks : [String] = []
    var favLooks : [String] = []
    var cartItems : [String:Int] = [:]
    
    var email : String?
    
    var username: String {
        return email?.replacingOccurrences(of: "@", with: "at").replacingOccurrences(of: ".", with: "dot") ?? "test"
    }
    
    private init() {}
    
}
    
