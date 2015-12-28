//
//  DetailMusicViewController.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/21/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import QuartzCore
import AudioToolbox

class DetailMusicViewController: UIViewController {
    
    // -------------------------------------------------------------------------------
    // MARK: - Properties
    
    var song: Song?
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    var morseCode: MorseCode?
    
    // -------------------------------------------------------------------------------
    // MARK: - IBOutlets
    
    @IBOutlet private var trackImage: UIImageView!
    @IBOutlet private var backTextImage: UIImageView!
    @IBOutlet private var trackTitleLabel: UILabel!
    @IBOutlet private var artistNameLabel: UILabel!
    @IBOutlet private var trackCollectionLabel: UILabel!
    @IBOutlet private var trackPriceLabel: UILabel!
    @IBOutlet private var trackLengthLabel: UILabel!
    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var morseButton: UIButton!
    
    // -------------------------------------------------------------------------------
    // MARK: - Super Class Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.customize()
        self.configureForSong()
        self.title = "Details"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "finishedPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        if let morseCode = self.morseCode {
            if morseCode.isNowPlaying() {
                morseCode.stopMorse()
            }
        }
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Other Initialisation Methods
    
    /**
    Customize some interface elements
    */
    private func customize() {
        self.playButton.layer.cornerRadius = 3.0
        self.playButton.layer.masksToBounds = true
        self.morseButton.layer.cornerRadius = 3.0
        self.morseButton.layer.masksToBounds = true
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Configuration methods
    
    /**
    Configure the Interface for the given song
    */
    func configureForSong() {
        
        if let songObject = self.song  {
            
            // Track Name
            if let trackName = songObject.trackName {
                self.trackTitleLabel.text! = "\"\(trackName)\""
                self.morseCode = MorseCode(string: trackName)
            }
            else {
                self.trackTitleLabel.text! = "No Title Information"
                self.morseButton.enabled = false
            }
            
            // Artist Name
            if let artistName = songObject.artistName {
                self.artistNameLabel.text! = "By \(artistName)"
            }
            else {
                self.artistNameLabel.text! = "No Artist Information"
            }
            
            // Collection
            if let collectionName = songObject.collectionName {
                self.trackCollectionLabel.text! = "From \(collectionName) Album"
            }
            else {
                self.trackCollectionLabel.text! = "No Album Information"
            }
            
            if let imageStringUrl = songObject.artworkUrl100 {
                let imageUrl = NSURL(string: imageStringUrl)
                self.trackImage.kf_setImageWithURL(imageUrl!, placeholderImage: UIImage.imageWithLocalName(localName: iTunesImageNames.iTunesImage), optionsInfo: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                    //To do ...
                })
            }
            
            //Set the length Information
            if let length = songObject.trackTimeMillis {
                let timeInterval = NSTimeInterval(length/1000)
                self.trackLengthLabel.text! = "Duration: \(timeInterval.minutesSeconds)"
            }
            else {
                self.trackLengthLabel.text! = ""
            }
            
            
            //Set the price information
            if let price = songObject.trackPrice {
                self.trackPriceLabel.text! = "Price: \(price)"
                if let currency = songObject.currency {
                    self.trackPriceLabel.text!.appendContentsOf(" \(currency)")
                }
            }
            else {
                self.trackPriceLabel.text! = ""
            }
            
            //Set the corner radius
            self.trackImage.layer.cornerRadius = 3.0
            self.trackImage.layer.masksToBounds = true
            
            self.backTextImage.layer.cornerRadius = 3.0
            self.backTextImage.layer.masksToBounds = true
            
            // Play song configuration
            if let previewUrl = self.song?.previewUrl {
                let url = NSURL(string: previewUrl)
                playerItem = AVPlayerItem(URL: url!)
                player=AVPlayer(playerItem: playerItem!)
            }
            else
            {
                self.playButton.enabled = false
            }
            
            // Add right button for navigation bar
            let actionButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "songAction")
            navigationItem.rightBarButtonItems = [actionButton]
        }
        else {
            self.showAlertMessage("Sorry", alertMessage: "An error has occured")
        }
    }
    
    /**
     Show the pop up action sheet for core data operations
     */
    func songAction() {
        let actionSheetTitle: String
        let actionSheetButtonAction: UIAlertAction
        
        // Posibility to store or delete the song to database if not exit
        if !CoreDataAPI.checkIfTrackAlreadyIsStored(self.song!.trackId!) {
            actionSheetTitle = "You can add this song to local storage"
            actionSheetButtonAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                do {
                    try CoreDataAPI.saveNewSong(self.song!)
                    NotificationManager.postCoreDataModelUpdateNotification()
                    self.showAlertMessage("Succes", alertMessage: "Song added to local storage")
                }
                catch {
                    self.showAlertMessage("Failure", alertMessage: "Unable to add to local storage")
                }
            })
        }
        else {
            actionSheetTitle = "This song is added to local storage"
            actionSheetButtonAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (alertAction) -> Void in
                do {
                    try CoreDataAPI.deleteSongWithTrackID(self.song!.trackId!)
                    NotificationManager.postCoreDataModelUpdateNotification()
                    self.showAlertMessage("Succes", alertMessage: "Song deleted from local storage")
                }
                catch {
                    self.showAlertMessage("Failure", alertMessage: "Unable to delete from local storage")
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let actionSheet = UIAlertController(title: actionSheetTitle, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheet.addAction(actionSheetButtonAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    /**
     Handler for finishing plaing notification of AVPlayer - set the play button title to "Play"
     
     - parameter myNotification: AvPplayerNotification
     */
    func finishedPlaying(myNotification:NSNotification) {
        self.playButton.setTitle("Play", forState: UIControlState.Normal)
        let stopedPlayerItem: AVPlayerItem = myNotification.object as! AVPlayerItem
        stopedPlayerItem.seekToTime(kCMTimeZero)
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - IBActions
    
    /**
    Play or continue playing the song
    
    - parameter sender: Button
    */
    @IBAction func playSong(sender: UIButton) {
        
        if player?.rate == 0
        {
            // Check if there is a internet connection
            if !NetworkAPI.isConnectedToNetwork() {
                self.showAlertMessage("Warning", alertMessage: "No internet connection")
            }
            player!.play()
            self.playButton.setTitle("Pause", forState: UIControlState.Normal)
        } else {
            player!.pause()
            self.playButton.setTitle("Play", forState: UIControlState.Normal)
        }
    }
    
    /**
     Interpret morse with vibration and toch light
     
     - parameter sender: Button
     */
    @IBAction func playMorse(sender: UIButton) {
        //self.showAlertMessage("Sorry", alertMessage: "Not implemented")
        if let morseCode = self.morseCode {
            if morseCode.isNowPlaying() {
                morseCode.stopMorse()
                self.morseButton.setTitle("Morse", forState: UIControlState.Normal)
            }
            else {
                morseCode.playMorse( {
                    self.morseButton.setTitle("Morse", forState: UIControlState.Normal)
                } )
                self.morseButton.setTitle("Stop", forState: UIControlState.Normal)
            }
        }
    }
    
    /**
     Open the artist web Page
     */
    @IBAction func showArtistPage(sender: UIButton) {
        print("Show Artist Page \(self.song?.artistViewUrl)")
        if let artistViewUrl = self.song?.artistViewUrl {
            if let url = NSURL(string: artistViewUrl) {
                if UIApplication.sharedApplication().canOpenURL(url){
                    UIApplication.sharedApplication().openURL(url)
                }
            }
        }
    }
    
    /**
     Open the album web Page
     */
    @IBAction func showAlbumPage(sender: UIButton) {
        print("Show Album Page \(self.song?.collectionViewUrl)")
        if let albumViewUrl = self.song?.collectionViewUrl {
            if let url = NSURL(string: albumViewUrl) {
                if UIApplication.sharedApplication().canOpenURL(url){
                    UIApplication.sharedApplication().openURL(url)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}

