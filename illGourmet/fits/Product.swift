//
//  Product.swift
//  fits
//
//  Created by Vibes on 4/12/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation
import UIKit

class Product {
    
    var productImage : String
    var brandName : String
    var productName : String
    var price : Double
    var tags : [String] = []
    var lookID : String
    var image : UIImage?
    var productID : String
    
    private let queue = DispatchQueue(label: "privateQueue", qos: DispatchQoS.background, attributes: .concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)

    
    init(productImage : String, brandName : String, productName : String, price: Double, lookID : String, productID : String) {
        
        self.productImage = productImage
        self.brandName = brandName
        self.productName = productName
        self.price = price 
        self.lookID = lookID
        self.productID = productID
        
    }
    
    public func loadImage(completion : @escaping (UIImage) -> Void)  {
        queue.async {
            if let image = self.image {
                completion(image)
            } else {
                
                Firebase.shared.storageRef.storage.reference(forURL: self.productImage).data(withMaxSize: INT64_MAX, completion: { (data, error) in
                    print(error)
                    guard let data = data else { return }
                    if let newImage = UIImage(data: data) {
                        self.image = newImage
                        completion(newImage)
                    }
                })
                
                //                if let data = try? Data(contentsOf: url) {
                //                    if let newImage = UIImage(data: data) {
                //                        self.image = newImage
                //                        completion(newImage)
                //                    }
                //                }
            }
        }
    }
}
