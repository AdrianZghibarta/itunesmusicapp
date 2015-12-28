//
//  CDSong.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/16/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit
import CoreData

@objc(CDSong)
class CDSong: NSManagedObject {
    
    // ---------------------------------------------------------------------------
    // MARK: - Proprietes
    
    @NSManaged var artistId: NSNumber?
    @NSManaged var artistName: String?
    @NSManaged var artistViewUrl: String?
    @NSManaged var artworkUrl100: String?
    @NSManaged var artworkUrl60: String?
    @NSManaged var artworkUrl30: String?
    @NSManaged var previewUrl: String?
    @NSManaged var trackCensoredName: String?
    @NSManaged var trackId: NSNumber?
    @NSManaged var trackName: String?
    @NSManaged var trackPrice: NSNumber?
    @NSManaged var currency: String?
    @NSManaged var trackTimeMillis: NSNumber?
    @NSManaged var collectionName: String?
    @NSManaged var collectionViewUrl: String?
    
    // ---------------------------------------------------------------------------
    // MARK: Methods
    
    /**
     Set all values for CoreData Object from Song Default Object
     
     - parameter song: Song Object
     */
    func cloneFromSongObject(songObject song:Song) {
        self.artistId = song.artistId
        self.artistName = song.artistName
        self.artistViewUrl = song.artistViewUrl
        self.artworkUrl100 = song.artworkUrl100
        self.artworkUrl60 = song.artworkUrl60
        self.artworkUrl30 = song.artworkUrl30
        self.previewUrl = song.previewUrl
        self.trackCensoredName = song.trackCensoredName
        self.trackId = song.trackId
        self.trackName = song.trackName
        self.trackPrice = song.trackPrice
        self.currency = song.currency
        self.trackTimeMillis = song.trackTimeMillis
        self.collectionName = song.collectionName
        self.collectionViewUrl = song.collectionViewUrl
    }
}
