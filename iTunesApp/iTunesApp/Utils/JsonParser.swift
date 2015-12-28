//
//  JsonParser.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/17/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit

/// Basic Json Parse Methods
class JsonParser: NSObject {
    
    /**
     Deserialize a JsonData into a NSDictionary
     
     - parameter jsonData: NSData to deserialize
     
     - returns: Deserizlized NSDictionary
     */
    class func parseJsonDataIntoDictionary(jsonData jsonData: NSData) -> NSDictionary? {
        
        var jsonDictionary: NSDictionary?
        
        do {
            jsonDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData,
                options: []) as? NSDictionary
        } catch  {
            print("Error in converting the data to json")
        }
        
        return jsonDictionary
    }
}
