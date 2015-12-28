//
//  DeviceManager.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/23/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit

import AudioToolbox
import AVFoundation

/// Device Utility methods
class DeviceManager: NSObject {
    
    /**
     Vibrate the phone if device support or play a bip signal
     */
    class func vibrate() {
        // Vibration
        if UIDevice.currentDevice().model == "iPhone" {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        else {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    /**
     Set the torch enabled or disabled
     
     - parameter enabled: Torch status to change
     */
    class func setTorchEnabled(enabled: Bool) {
        // Torch
        if let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) {
            if device.hasTorch {
                do {
                    // lock your device for configuration
                    try device.lockForConfiguration()
                    
                    if enabled {
                        // turn torch on
                        device.torchMode = AVCaptureTorchMode.On
                        // sets the torch intensity to 100%
                        try device.setTorchModeOnWithLevel(1.0)
                    }
                    else {
                        // turn torch off
                        device.torchMode = AVCaptureTorchMode.Off
                    }
                    
                    // unlock your device
                    device.unlockForConfiguration()
                }
                catch {
                    print("Torch is not available")
                }
            }
        }
    }
}
