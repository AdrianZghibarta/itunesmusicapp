//
//  LocalMusicViewController.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/16/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit

class LocalMusicViewController: UIViewController {

    // -------------------------------------------------------------------------------
    // MARK: - Properties
    
    private var songsArray = [CDSong]()
    private let cellIdentifier: String = "SongCell"
    var delegate: MusicContainerViewController?
    var searchString: String = ""
    
    // -------------------------------------------------------------------------------
    // MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noDatalabel: UILabel!
    @IBOutlet var noDataImage: UIImageView!
    
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
        
        // Get data for the first time
        self.fetchAllSongs("")
        self.reloadTableViewContent()
        
        // Subscribe to CoreDataChange notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationUpdate", name: NotificationManager.NMCoreDataModelUpdateNotificationKey, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // -------------------------------------------------------------------------------
    // MARK: IBActions
    
    
    // -------------------------------------------------------------------------------
    // MARK: - Other Functions
    
    /**
    Reload in main queue the tableview data
    */
    private func reloadTableViewContent() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        })
    }
    
    /**
     Action for NMCoreDataModelUpdateNotification
     */
    func notificationUpdate() {
        self.fetchAllSongs(self.searchString)
        self.reloadTableViewContent()
    }
    
    /**
     Fetch all songs from local storaga (all songs of search string is empty one)
     
     - parameter searchString: String for searching
     */
    private func fetchAllSongs(searchString: String) {
        do {
            self.songsArray = try CoreDataAPI.getSongsForSearchKeyword(self.searchString)
        }
        catch {
            self.showAlertMessage("Error", alertMessage: "Cant get song frome local storage")
        }
        self.setNoDataViewToHidden(self.songsArray.count > 0)
    }
    
    /**
     Hide or show the no data view for table view
     
     - parameter hidden: Bool value for hidden property of views
     */
    private func setNoDataViewToHidden(hidden: Bool) {
        
        print("Hide no data label for Local vc : \(hidden)")
        self.noDatalabel.hidden = hidden
        self.noDataImage.hidden = hidden
    }
    
    /**
     Check if the table view of view controller is in editing mode
     
     - returns: tableView editing value
     */
    func isInEditingMode() -> Bool {
        if self.songsArray.count == 0 {
            if self.tableView.editing {
                self.tableView.setEditing(false, animated: true)
            }
        }
        
        print(self.tableView.editing)
        return self.tableView.editing
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
// MARK: - MusicViewController extension for LocalMusicViewController
extension LocalMusicViewController: MusicViewController {
    func needToUpdateWithSearchString(searchString searchString: String) {
        self.searchString = searchString
        self.fetchAllSongs(self.searchString)
        self.reloadTableViewContent()
    }
}

// -------------------------------------------------------------------------------
// MARK: - UITableViewDelegate and DataSource extension for LocalMusicVewController
extension LocalMusicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as! SongTableViewCell
        let song = Song(coreDataSongObject: self.songsArray[indexPath.row])
        cell.configureForSong(song: song)
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            do {
                try CoreDataAPI.deleteSong(self.songsArray[indexPath.row])
                self.songsArray.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
                self.setNoDataViewToHidden(self.songsArray.count != 0)
            }
            catch {
                self.showAlertMessage("Error", alertMessage: "Please try later")
            }
        }
        
        return [delete]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let musicContainerViewController = self.delegate {
            let song = Song(coreDataSongObject: self.songsArray[indexPath.row])
            musicContainerViewController.needToDisplayDetailsForSong(song)
        }
    }
    
    
    /**
     Change the edting flag of the songs table view
     */
    func changeEditStatus() {
        self.tableView.editing = !self.tableView.editing
    }
}