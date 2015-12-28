//
//  SongTableViewCell.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/17/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit
import Kingfisher

class SongTableViewCell: UITableViewCell {

    // -------------------------------------------------------------------------------
    // MARK: Proprietes
    
    var song: Song?
    let cornerRadius: CGFloat = 3.0
    
    // -------------------------------------------------------------------------------
    // MARK: IBOutlets
    
    @IBOutlet private var trackImage: UIImageView!
    @IBOutlet private var backImage: UIImageView!
    @IBOutlet private var trackTitleLabel: UILabel!
    @IBOutlet private var artistNameLabel: UILabel!
    @IBOutlet private var trackPriceLabel: UILabel!
    
    // -------------------------------------------------------------------------------
    // MARK: Override Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // -------------------------------------------------------------------------------
    // MARK: Configuration methods
    
    /**
    Configure the cell to display the song
    
    - parameter song: Song to display
    */
    func configureForSong(song song: Song) {
        
        self.song = song
        
        self.trackTitleLabel.text! = song.trackName ?? "No Name"
        self.artistNameLabel.text! = song.artistName ?? "No Artist"
        
        if let imageStringUrl = song.artworkUrl100 {
            let imageUrl = NSURL(string: imageStringUrl)
            self.trackImage.kf_setImageWithURL(imageUrl!, placeholderImage: UIImage(named: "iTunesImage"), optionsInfo: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                // To do ...
            })
        }
        
        //Set the price label
        if let price = song.trackPrice {
            self.trackPriceLabel.text! = "\(price)"
            if let currency = song.currency {
                self.trackPriceLabel.text!.appendContentsOf(" \(currency)")
            }
        }
        else {
            self.trackPriceLabel.text! = "No Price Information"
        }
        
        //Set the corner radius
        self.trackImage.layer.cornerRadius = self.cornerRadius
        self.backImage.layer.cornerRadius = self.cornerRadius
        
    }
}
