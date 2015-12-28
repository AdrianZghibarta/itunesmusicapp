//
//  CoreDataAPI.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/16/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit
import CoreData

enum EntityNames : String {
    case Song = "Song"
    
}

enum Attributes : String {
    case songName = "songName"
}

/// Get, insert and delete operations for Core Data Model
class CoreDataAPI: NSObject {
    
    // ---------------------------------------------------------------------------
    //  MARK: Music API methods
    
    /**
    Get all songs stored from coreDataModel who mach the given search Keyword
    
    - parameter searchKeyword: searchKeyword
    
    - throws: Can throw an error
    
    - returns: CDSongs who match the search keyword
    */
    class func getSongsForSearchKeyword(searchKeyword: String) throws -> [CDSong] {
        let managedContext = CoreDataManager.sharedInstance().managedObjectContext
        
        // Fetch reqest for entity Song
        let fetchRequest = NSFetchRequest(entityName: EntityNames.Song.rawValue)
        
        // Adding the predicate
        if !searchKeyword.isEmpty{
            let predicate = NSPredicate(format: "(trackId CONTAINS[cd] %@) OR (artistName CONTAINS[cd] %@) OR (trackCensoredName CONTAINS[cd] %@) OR (trackName CONTAINS[cd] %@)", searchKeyword, searchKeyword, searchKeyword, searchKeyword)
            fetchRequest.predicate = predicate
        }
        
        // Getting the result and return an error or the Songs as ManagedObjects (CDSOngs)
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest) as! [CDSong]
            return results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            throw error
        }
    }
    
    /**
     Check if there is already stored localy a track with given id
     
     - parameter trackId: trackId of the song
     
     - returns: true if song is sotred already localy and false in other case
     */
    class func  checkIfTrackAlreadyIsStored(trackId: NSNumber) -> Bool {
        let managedContext = CoreDataManager.sharedInstance().managedObjectContext
        
        // Fetch reqest for entity Song
        let fetchRequest = NSFetchRequest(entityName: EntityNames.Song.rawValue)
        
        // Adding the predicate
        let predicate = NSPredicate(format: "trackId == %@", "\(trackId)")
        fetchRequest.predicate = predicate
        
        // Getting the result and return an error or the Songs as ManagedObjects (CDSongs)
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest) as! [CDSong]
            return ( results.count > 0 ) ? true : false
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
    }
    
    /**
     Save a Song object in the CoreData model
     
     - parameter song: Song object to store
     
     - throws: Can throw an exception
     
     - returns: CDSong object inserted
     */
    class func saveNewSong(song: Song) throws -> CDSong {
        let managedContext = CoreDataManager.sharedInstance().managedObjectContext
        
        // Get the object to insert for Song entitiy and given managedObjectContex
        let songToInsert: CDSong = NSEntityDescription.insertNewObjectForEntityForName(EntityNames.Song.rawValue, inManagedObjectContext: managedContext) as! CDSong
        
        // Set the needed values for the Song to insert
        songToInsert.cloneFromSongObject(songObject: song)
        
        // Save the new Song
        do {
            try managedContext.save()
            return songToInsert
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            throw error
        }
    }
    
    /**
     Delete the CDSong object from the store and save the context
     
     - parameter song: CDSong to delete from CD Storage
     
     - throws: Can Throw an exception
     */
    class func deleteSong(song: CDSong) throws {
        CoreDataManager.sharedInstance().managedObjectContext.deleteObject(song)
        CoreDataManager.sharedInstance().saveContext()
    }
    
    class func deleteSongWithTrackID(trackId: NSNumber) throws {
        let managedContext = CoreDataManager.sharedInstance().managedObjectContext
        
        // Fetch reqest for entity Song
        let fetchRequest = NSFetchRequest(entityName: EntityNames.Song.rawValue)
        
        // Adding the predicate
        let predicate = NSPredicate(format: "trackId == %@", "\(trackId)")
        fetchRequest.predicate = predicate
        
        // Getting the result and return an error or the Songs as ManagedObjects (CDSongs)
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest) as! [CDSong]
            if (results.count > 0){
                CoreDataManager.sharedInstance().managedObjectContext.deleteObject(results[0])
                CoreDataManager.sharedInstance().saveContext()
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            throw error
        }
    }
}