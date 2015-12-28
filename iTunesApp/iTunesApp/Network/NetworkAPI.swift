//
//  NetworkAPI.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/16/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

/// Network Api methods
class NetworkAPI: NSObject {
    
    /**
     *  All URLs and Network Constants
     */
    struct NetworkKeys {
        static let BaseURL = "http://itunes.apple.com/search?"
    }
    
    /**
     Initialize a singleton instance
     
     - returns: Singleton NetworkAPI Object
     */
    class func sharedInstance() -> NetworkAPI{
        struct Singleton {
            
            static private let instance = NetworkAPI()
        }
        return Singleton.instance
    }
    
    
    // MARK: Proprietes
    
    private let config: NSURLSessionConfiguration
    private let session: NSURLSession
    
    // MARK: Initializer
    
    override init() {
        self.config = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: config)
    }
    
    
    /**
    Request to GET all songs that match the search string pattern
    
    - parameter searchString:      Search String
    - parameter completionHandler: Completition handler
    
    - returns: NSURLSesstionTask
    */
    func getSongs(searchString: String, limit: Int, succesHandler: (songList: [Song]) -> Void, errorHandler: (errorMessage: String) -> Void) -> NSURLSessionTask? {
        
        if !NetworkAPI.isConnectedToNetwork() {
            errorHandler(errorMessage: "No internet connection!")
            return nil
        }
        
        var parsedSearchString = searchString
        parsedSearchString.replaceBlankSpaces()
        let url = NSURL(string: NetworkKeys.BaseURL + "term=\(parsedSearchString)&limit=\(limit)&media=music")
        let urlRequest = NSURLRequest(URL: url!)
        print(url)
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            
            guard let _ = data else {
                errorHandler(errorMessage: "Error while getting the response data")
                return
            }
            guard error == nil else {
                errorHandler(errorMessage: "Error while getting the response data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            if let responseDictionary = JsonParser.parseJsonDataIntoDictionary(jsonData: data!) {
                print("The response is: " + responseDictionary.description)
                
                //Get the song array
                if let dictionaryArray = responseDictionary["results"] as? [NSDictionary] {
                    let songs = Song.getBulkSongs(fromDictionaryArray: dictionaryArray)
                    succesHandler(songList: songs)
                }
                else {
                    errorHandler(errorMessage: "Error processing the information")
                }
            }
            else {
                errorHandler(errorMessage: "Error while converting the data into Json")
            }
            
        })
        task.resume()
        return task
    }
    
    /**
     Check if there is an active network connection for the device
     
     - returns: Network connetion status (Bool)
     */
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
