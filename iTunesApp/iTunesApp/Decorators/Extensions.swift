//
//  Extensions.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/21/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     Show alert message
     
     - parameter alertTitle:   Alert Title
     - parameter alertMessage: Alert Message
     */
    func showAlertMessage(alertTitle: String, alertMessage: String){
        //Define the action shet
        let actionSheet = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) -> Void in
            // To implement if needed
        }
        // Add the actions to the action Sheet
        actionSheet.addAction(cancelAction)
        
        // Show the action sheet
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
}

// ---------------------------------------------------------------------------
// MARK: - String extension for web parsing
extension String {
    /**
     Replace in the self string object the occurence of blanck spaces with '+' character
     */
    mutating func replaceBlankSpaces() {
        self = self.stringByReplacingOccurrencesOfString(" ", withString: "+")
    }
}

// ---------------------------------------------------------------------------
// MARK: NSTimeInterval Extension for displaing the minutes and second from a miliseconds
extension NSTimeInterval {
    
    /// Minues : Seconds : Miliseconds time interval format
    var minuteSecondMS: String {
        return String(format:"%d:%02d.%03d", minute , second, millisecond)
    }
    /// Minues : Seconds time interval format
    var minutesSeconds: String {
        return String(format:"%d:%02d", minute , second)
    }
    /// Minues time interval format
    var minute: Int {
        return Int((self/60.0)%60)
    }
    /// Seconds time interval format
    var second: Int {
        return Int(self % 60)
    }
    /// Miliseconds time interval format
    var millisecond: Int {
        return Int(self*1000 % 1000 )
    }
}
