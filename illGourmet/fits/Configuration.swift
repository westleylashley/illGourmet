//
//  Configuration.swift
//  fits
//
//  Created by Vibes on 4/11/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation

public class Configuration {
    /*
     The value of the `EMPORIUM_BUNDLE_PREFIX` user-defined build setting is
     written to the Info.plist file of every target in Swift version of the
     Emporium project. Specifically, the value of `EMPORIUM_BUNDLE_PREFIX` is
     used as the string value for a key of `AAPLEmporiumBundlePrefix`. This value
     is loaded from the target's bundle by the lazily evaluated static variable
     "prefix" from the nested "Bundle" struct below the first time that "Bundle.prefix"
     is accessed. This avoids the need for developers to edit both `EMPORIUM_BUNDLE_PREFIX`
     and the code below. The value of `Bundle.prefix` is then used as part of
     an interpolated string to insert the user-defined value of `EMPORIUM_BUNDLE_PREFIX`
     into several static string constants below.
     */
    
    private struct MainBundle {
        static var prefix = Bundle.main.object(forInfoDictionaryKey: "AAPLEmporiumBundlePrefix") as! String
    }
    
    struct Merchant {
        static let identififer = "merchant.\(MainBundle.prefix).Emporium"
    }
}
