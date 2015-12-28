//
//  MorseCode.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/23/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit

/// Class who permet to convert a string in Morse code and play it with vibration and flashlight
class MorseCode: NSObject {
    
    // ---------------------------------------------------------------------------
    // MARK: - Properties
    private var morseString: String = ""
    private var playThread: NSThread? // A good idea is to use NSOperation
    private var isPlaying: Bool = false
    private var endPlayingHandler: (() -> ())?
    
    // ---------------------------------------------------------------------------
    // MARK: - Instance functions
    
    /**
     Initialize a MorseCodeObject with a string to conver
     
     - parameter string: string to convert
     
     - returns: MorseCode Object with morse converted string
     */
    init(string: String) {
        super.init()
        self.morseString = MorseCode.getMorseStringFromString(string)
    }
    
    /**
     Play instance stored morse string
     */
    func playMorse(endPlayingHandler: () -> ()) {
        self.endPlayingHandler = endPlayingHandler
        self.playThread = NSThread(target: self, selector: "playMorseThreadAction", object: nil)
        self.playThread?.start()
        self.isPlaying = true
    }
    
    /**
     Cancel the morse playing
     */
    func stopMorse() {
        self.playThread?.cancel()
        self.isPlaying = false
    }
    
    func isNowPlaying() -> Bool {
        return self.isPlaying
    }
    
    /**
     Action for playing thread
     */
    func playMorseThreadAction() {
        for character in self.morseString.characters {
            if !self.isPlaying {
                return
            }
            
            var numberOfBips = 1
            if character == "-" {
                numberOfBips = 3
            }
            
            for _ in 0..<numberOfBips {
                if !self.isPlaying {
                    return
                }
                
                DeviceManager.vibrate()
                DeviceManager.setTorchEnabled(true)
                DeviceManager.setTorchEnabled(false)
                NSThread.sleepForTimeInterval(1)
                
                if !self.isPlaying {
                    return
                }
            }
            
            if !self.isPlaying {
                return
            }
            
            NSThread.sleepForTimeInterval(1)
        }
        
        if let handler =  self.endPlayingHandler {
            handler()
        }
    }
    
    // ---------------------------------------------------------------------------
    // MARK: Class Functions
    
    /**
     Get the morse code from a string
     
     - parameter string: string to transform in morse code
     
     - returns: morse code as string
     */
    static func getMorseStringFromString(string: String) -> String {
        
        var morseString = ""
        for character in string.characters {
            morseString.appendContentsOf(getMorseCodeFromCharacters(character))
        }
        return morseString
    }
    
    
    /**
     Transform a single character into morse code
     
     - parameter character: character to transform in morse code
     
     - returns: morse code of character as string
     */
    static func getMorseCodeFromCharacters(character: Character) -> String {
        
        let upperCaseCharacter = String(character).uppercaseString
        switch (upperCaseCharacter) {
            
            // Letters
            case "A": return ".-"
            case "B": return "-..."
            case "C": return "-.-."
            case "D": return "-.."
            case "E": return "."
            case "F": return "..-."
            case "G": return "--."
            case "H": return "...."
            case "I": return ".."
            case "J": return ".---"
            case "K": return "-.-"
            case "L": return ".-.."
            case "M": return "--"
            case "N": return "-."
            case "O": return "---"
            case "P": return ".--."
            case "Q": return "--.-"
            case "R": return ".-."
            case "S": return "..."
            case "T": return "-"
            case "U": return "..-"
            case "V": return "...-"
            case "W": return ".--"
            case "X": return "-..-"
            case "Y": return "-.--"
            case "Z": return "--.."
            
            // Numbers
            case "0": return "-----"
            case "1": return ".----"
            case "2": return "..---"
            case "3": return "...--"
            case "4": return "....-"
            case "5": return "....."
            case "6": return "-...."
            case "7": return "--..."
            case "8": return "---.."
            case "9": return "----."
            
            // Dot signs
            case ".": return ".-.-.-"
            case ",": return "--..--"
            
            // Defaul value is empty string
            default: return ""
        }
    }
}
