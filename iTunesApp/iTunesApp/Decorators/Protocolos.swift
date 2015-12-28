//
//  Protocolos.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/21/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit

/**
 *  The class who implement this protocol can display a detail page for a Song
 */
protocol MusicContainerViewController {
    
    /**
     Another object need to display song details
     
     - parameter song: Song to display
     */
    func needToDisplayDetailsForSong(song: Song)
}

/**
 *  The class who implement this protocol can perfirm a search request with given search parameter
 */
protocol MusicViewController {
    
    /**
     Another object need to perform a search request
     
     - parameter searchString: Search String
     */
    func needToUpdateWithSearchString(searchString searchString: String)
}