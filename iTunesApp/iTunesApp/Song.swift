//
//  Song.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/17/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit

class Song: NSObject {
    
    /**
     *  All the attributes keys for the Song Object
     */
    struct SongKeys {
        static let artistId = "artistId"
        static let artistName = "artistName"
        static let artistViewUrl = "artistViewUrl"
        static let artworkUrl100 = "artworkUrl100"
        static let artworkUrl60 = "artworkUrl60"
        static let artworkUrl30 = "artworkUrl30"
        static let previewUrl = "previewUrl"
        static let trackCensoredName = "trackCensoredName"
        static let trackId = "trackId"
        static let trackName = "trackName"
        static let trackPrice = "trackPrice"
        static let currency = "currency"
        static let trackTimeMillis = "trackTimeMillis"
        static let collectionName = "collectionName"
        static let collectionViewUrl = "collectionViewUrl"
        
    }
    
    // ---------------------------------------------------------------------------
    // MARK: - Proprietes
    
    var artistId: Int?
    var artistName: String?
    var artistViewUrl: String?
    var artworkUrl100: String?
    var artworkUrl60: String?
    var artworkUrl30: String?
    var previewUrl: String?
    var trackCensoredName: String?
    var trackId: Int?
    var trackName: String?
    var trackPrice: Float?
    var currency: String?
    var trackTimeMillis: Int?
    var collectionName: String?
    var collectionViewUrl: String?
    
    
    // -------------------------------------------------------------------------------
    // MARK: - Methods
    
    /**
     Inialize a Song object from a Json Dictionary
     
     - parameter dictionary: Json Dictionary
     
     - returns: Song Object
     */
    init(dictionary: NSDictionary) {
        self.artistId = dictionary[SongKeys.artistId] as? Int
        self.artistName = dictionary[SongKeys.artistName] as? String
        self.artistViewUrl = dictionary[SongKeys.artistViewUrl] as? String
        self.artworkUrl100 = dictionary[SongKeys.artworkUrl100] as? String
        self.artworkUrl60 = dictionary[SongKeys.artworkUrl60] as? String
        self.artworkUrl30 = dictionary[SongKeys.artworkUrl30] as? String
        self.previewUrl = dictionary[SongKeys.previewUrl] as? String
        self.trackCensoredName = dictionary[SongKeys.trackCensoredName] as? String
        self.trackId = dictionary[SongKeys.trackId] as? Int
        self.trackName = dictionary[SongKeys.trackName] as? String
        self.trackPrice = dictionary[SongKeys.trackPrice] as? Float
        self.currency = dictionary[SongKeys.currency] as? String
        self.trackTimeMillis = dictionary[SongKeys.trackTimeMillis] as? Int
        self.collectionName = dictionary[SongKeys.collectionName] as? String
        self.collectionViewUrl = dictionary[SongKeys.collectionViewUrl] as? String
    }
    
    /**
     Init a Song Object from a Core Data Song Object
     
     - parameter song: Core Data Song Object
     
     - returns: Song Object
     */
    init(coreDataSongObject song:CDSong) {
        self.artistId = song.artistId?.integerValue
        self.artistName = song.artistName
        self.artistViewUrl = song.artistViewUrl
        self.artworkUrl100 = song.artworkUrl100
        self.artworkUrl60 = song.artworkUrl60
        self.artworkUrl30 = song.artworkUrl30
        self.previewUrl = song.previewUrl
        self.trackCensoredName = song.trackCensoredName
        self.trackId = song.trackId?.integerValue
        self.trackName = song.trackName
        self.trackPrice = song.trackPrice?.floatValue
        self.currency = song.currency
        self.trackTimeMillis = song.trackTimeMillis?.integerValue
        self.collectionName = song.collectionName
        self.collectionViewUrl = song.collectionViewUrl
    }
    
    
    /**
     Transform an array of json dictionaries in to an array of Songs
     
     - parameter arrayOfDictionary: Array with Json Dictionaries
     
     - returns: Array of Songs
     */
    class func getBulkSongs(fromDictionaryArray arrayOfDictionary: [NSDictionary]) -> [Song]{
        
        var songsArray = [Song]()
        
        for dictionary in arrayOfDictionary {
            songsArray.append(Song(dictionary: dictionary))
        }
        
        return songsArray
    }
}
