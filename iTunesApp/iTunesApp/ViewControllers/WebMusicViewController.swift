//
//  WebMusicViewController.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/16/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit

class WebMusicViewController: UIViewController {
    
    // -------------------------------------------------------------------------------
    // MARK: - Properties
    
    private var songsArray = [Song]()
    private let cellIdentifier: String = "SongCell"
    var delegate: MusicContainerViewController?
    var searchString: String = ""
    let paginator: PaginationManager = PaginationManager(maxNumberOfObject: 200, itemsPerPage: 10)
    
    // -------------------------------------------------------------------------------
    // MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noDatalabel: UILabel!
    @IBOutlet var noDataImage: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // -------------------------------------------------------------------------------
    // MARK: - Super Class Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 77.0
        self.tableView.registerNib(UINib.init(nibName: "SongTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 0.01))
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 0.01))
        
        // Check if there is a internet connection
        if !NetworkAPI.isConnectedToNetwork() {
            self.showAlertMessage("Warning", alertMessage: "For web search you need to be connected to web services")
        }
        
        // Set the handlers for the Pagination Manager
        self.paginator.nextPageHandler = { newPageNumber, actualItemsNumber in
            NetworkAPI.sharedInstance().getSongs(self.searchString, limit: actualItemsNumber, succesHandler:
                { (songList) -> Void in
                    self.songsArray = songList
                    self.reloadTableViewContent()
                })
                { (errorMessage) -> Void in
                    print(errorMessage)
                    self.showAlertMessage("Error", alertMessage: errorMessage)
                    self.stopActivityIndicator()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - IBActions
    
    // -------------------------------------------------------------------------------
    // MARK: - Other Functions
    
    /**
    Reload all table view data in main thread
    */
    private func reloadTableViewContent() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        })
    }
    
    /**
     Stop the animation of the activity indicator in main thread
     */
    private func stopActivityIndicator() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.activityIndicator.stopAnimating()
            self.setNoDataViewToHidden((self.songsArray.count > 0))
        })
    }
    
    /**
     Hide or show the no data view for table view
     
     - parameter hidden: Bool value for hidden property of views
     */
    private func setNoDataViewToHidden(hidden: Bool) {
        self.noDatalabel.hidden = hidden
        self.noDataImage.hidden = hidden
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

// -------------------------------------------------------------------------------
// MARK: - MusicViewController extension for WebMusicViewController
extension WebMusicViewController: MusicViewController {
    
    func needToUpdateWithSearchString(searchString searchString: String) {
        self.activityIndicator.startAnimating()
        self.searchString = searchString
        NetworkAPI.sharedInstance().getSongs(searchString, limit: 10, succesHandler:
            { (songList) -> Void in
                self.songsArray = songList
                self.reloadTableViewContent()
                self.stopActivityIndicator()
                self.paginator.resetPages()
            })
            { (errorMessage) -> Void in
                print(errorMessage)
                self.showAlertMessage("Error", alertMessage: errorMessage)
                self.stopActivityIndicator()
                self.paginator.resetPages()
        }
    }
}

// -------------------------------------------------------------------------------
// MARK: - Extension for UITableViewDelegate and DataSource
extension WebMusicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.paginator.hasFinishPagination() || self.songsArray.count == 0 {
            return nil
        }
        else {
            let footerView = NSBundle.mainBundle().loadNibNamed("InfiniteScrollingFooter", owner: self, options: nil)[0] as! UIView
            return footerView
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.paginator.hasFinishPagination() || self.songsArray.count == 0 {
            return 0
        }
        else {
            return 35
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as! SongTableViewCell
        cell.configureForSong(song: self.songsArray[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let musicContainerViewController = self.delegate {
            musicContainerViewController.needToDisplayDetailsForSong(self.songsArray[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.songsArray.count - 1 {
            self.paginator.nextPage()
        }
    }
}