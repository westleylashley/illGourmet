//
//  Look.swift
//  fits
//
//  Created by Vibes on 4/12/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation
import UIKit

class Look {
    
    var celebrityID : String
    var description : String
    var imageURL : String
    var postedByUserID : String
    var productIDs : [String]
    var image : UIImage?

    private let queue = DispatchQueue(label: "privateQueue", qos: DispatchQoS.background, attributes: .concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
    
    init( celebrityID : String, description : String , imageURL : String, postedByUserID : String, productIDs : [String]) {
        
        self.celebrityID = celebrityID
        self.description = description
        self.imageURL = imageURL
        self.postedByUserID = postedByUserID
        self.productIDs = productIDs
    }
    
    public func loadImage(completion : @escaping (UIImage) -> Void)  {
        queue.async {
            if let image = self.image {
                completion(image)
            } else {
                Firebase.shared.storageRef.storage.reference(forURL: self.imageURL).data(withMaxSize: INT64_MAX, completion: { (data, error) in
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

extension Look: Equatable {
    static func ==(lhs: Look, rhs: Look) -> Bool {
        guard lhs.celebrityID == rhs.celebrityID else { return false }
        guard lhs.description == rhs.description else { return false }
        guard lhs.imageURL == rhs.imageURL else { return false }
        guard lhs.productIDs == rhs.productIDs else { return false }
        return true
    }
}
