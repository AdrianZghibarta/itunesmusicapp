//
//  MasterViewController.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/16/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    // -------------------------------------------------------------------------------
    // MARK: - Properties
    
    /// View Controllers for UIPageController
    var viewControllerArray = [UIViewController]()
    /// UIPageViewController who will contain all pages
    var pageViewController = UIPageViewController()
    
    // -------------------------------------------------------------------------------
    // MARK: - IBOutlets
    
    /// Container View for UIPageController
    @IBOutlet var containerView: UIView!
    /// UISegmented Control who permet the navigation from one page to another
    @IBOutlet var segmentedControl: UISegmentedControl!
    /// Search bar for song search
    @IBOutlet var searchBar: UISearchBar!
    
    // -------------------------------------------------------------------------------
    // MARK: - Super Class Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initializePageViewController()
        self.updateNavigationBarForNewPageSelection()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Other Initialisation Methods
    
    /**
     Initialize the array of view controller (web and local music)
    */
    private func initializePages() {
        let webMusicPage = WebMusicViewController(nibName: "WebMusicViewController", bundle: nil)
        webMusicPage.delegate = self
        let localMusicPage = LocalMusicViewController(nibName: "LocalMusicViewController", bundle: nil)
        localMusicPage.delegate = self
        self.viewControllerArray.appendContentsOf([webMusicPage, localMusicPage])
    }
    
    /**
     Initialize the UIPageViewController and add it to the self.view with constraints
     */
    private func initializePageViewController() {
        //Initialize the pageViewConroller
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.view.backgroundColor = UIColor.clearColor()
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        //Add the pageViewController to the superView
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        //Set the initial page
        self.initializePages()
        
        //Set the second page is only for force xib otulets initialization
        self.pageViewController.setViewControllers([self.viewControllerArray[1]], direction: .Forward, animated: false, completion: nil)
        self.pageViewController.setViewControllers([self.viewControllerArray[0]], direction: .Forward, animated: false, completion: nil)
        
        //Set the constraints
        self.setConstraintsForPageViewController()
    }
    
    /**
     Set the constraints for the self.pageViewController (center and equal dimensions with self.containerView)
     */
    private func setConstraintsForPageViewController() {
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX: NSLayoutConstraint = NSLayoutConstraint(item: self.pageViewController.view, attribute: .CenterX, relatedBy: .Equal, toItem: self.containerView, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let centerY: NSLayoutConstraint = NSLayoutConstraint(item: self.pageViewController.view, attribute: .CenterY, relatedBy: .Equal, toItem: self.containerView, attribute: .CenterY, multiplier: 1, constant: 0)
        
        let equalWidth: NSLayoutConstraint = NSLayoutConstraint(item: self.pageViewController.view, attribute: .Width, relatedBy: .Equal, toItem: self.containerView, attribute: .Width, multiplier: 1, constant: 0)
        
        let equalHeight: NSLayoutConstraint = NSLayoutConstraint(item: self.pageViewController.view, attribute: .Height, relatedBy: .Equal, toItem: self.containerView, attribute: .Height, multiplier: 1, constant: 0)
        
        self.view.addConstraints([centerX, centerY, equalHeight, equalWidth])
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - IBActions
    
    /**
     Update the page controller when new value are selected for uisegmented control
    
    - parameter sender: UISegmentedControl sender
    */
    @IBAction func didSelectNewSegment(sender: UISegmentedControl) {
        // Get the actual pageViewController index
        let actualPageViewControllerIndex = self.viewControllerArray.indexOf(self.pageViewController.viewControllers![0])
        
        // Determinate the direction of pageViewController animation depending on actual pageIndex
        let direction: UIPageViewControllerNavigationDirection = (actualPageViewControllerIndex! < sender.selectedSegmentIndex) ? .Forward : .Reverse
        
        // Update the PageViewController view controller
        self.pageViewController.setViewControllers([self.viewControllerArray[sender.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
        self.updateNavigationBarForNewPageSelection()
    }
    
    /**
     Change the LocalMusicViewController tableView editing bool value
     */
    @IBAction func putLocalTableViewInEditingMode() {
        for object in self.viewControllerArray {
            if let localVC = object as? LocalMusicViewController {
                localVC.changeEditStatus()
                if localVC.isInEditingMode() {
                    self.addDoneRightBarButton()
                }
                else {
                    self.addTrashRightBarButton()
                }
            }
        }
    }
    
    /**
     Update the navigation bar when a new page is shown (segment is selected) - Add or remouve the right edit button
     */
    private func updateNavigationBarForNewPageSelection() {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.navigationItem.rightBarButtonItem = nil
        }
        else {
            for object in self.viewControllerArray {
                if let localVC = object as? LocalMusicViewController {
                    if localVC.isInEditingMode() {
                        self.addDoneRightBarButton()
                    }
                    else {
                        self.addTrashRightBarButton()
                    }
                }
            }
        }
    }
    
    /**
     Set the right bar button as trash who put the LocalMusicViewController table view in editing mode
     */
    private func addTrashRightBarButton() {
        let trashButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "putLocalTableViewInEditingMode")
        self.navigationItem.rightBarButtonItem = trashButton
    }
    
    /**
     Set the right bar button as done button who end the LocalMusicVieController table view edtining mode
     */
    private func addDoneRightBarButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "putLocalTableViewInEditingMode")
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }

}

// -------------------------------------------------------------------------------
// MARK: - Requests Extensions for MasterViewController
extension MasterViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for viewController in self.viewControllerArray {
            if let musicViewController = viewController as? MusicViewController {
                musicViewController.needToUpdateWithSearchString(searchString: searchBar.text!)
            }
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
}

// -------------------------------------------------------------------------------
// MARK: -  MusicContainerViewController protocol extension for MasterViewController
extension MasterViewController: MusicContainerViewController {
    
    func needToDisplayDetailsForSong(song: Song) {
        self.searchBar.endEditing(true)
        let detailsPage = DetailMusicViewController(nibName: "DetailMusicViewController", bundle: nil)
        detailsPage.song = song
        self.navigationController?.pushViewController(detailsPage, animated: true)
    }
}

// -------------------------------------------------------------------------------
// MARK: - UIPageViewController Extenstion for MasterViewController
extension MasterViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let actualIndex = self.viewControllerArray.indexOf(viewController)
        
        if actualIndex == self.viewControllerArray.count - 1 {
            return nil
        }
        
        return self.viewControllerArray[actualIndex! + 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let actualIndex = self.viewControllerArray.indexOf(viewController)
        
        if actualIndex == 0 {
            return nil
        }
        
        return self.viewControllerArray[actualIndex! - 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let destinationViewController = pageViewController.viewControllers![0]
        
        let newIndex = self.viewControllerArray.indexOf(destinationViewController)
        
        self.segmentedControl.selectedSegmentIndex = newIndex!
        self.updateNavigationBarForNewPageSelection()
    }
}