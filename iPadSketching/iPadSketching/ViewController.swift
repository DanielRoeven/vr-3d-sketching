//
//  ViewController.swift
//  iPadSketching
//
//  Created by Daniel Roeven on 21/04/2018.
//  Copyright © 2018 Daniel Roeven. All rights reserved.
//

import UIKit
import SwiftOSC

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var ipaddress = "192.168.0.101"
    var port = 8000
    var client = OSCClient(address: "192.168.0.1", port: 8000)
    let address = OSCAddressPattern("/iPadSketching/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Variables describing gesture state
    var gestures = Set<UIGestureRecognizer>(minimumCapacity: 3)
    var state:Int = 0
    var x:CGFloat = -1
    var y:CGFloat = -1
    var rotation:CGFloat = 0
    var rotationDiff:CGFloat = 0
    var rotationThresholdPassed = false
    var scale:CGFloat = 1
    var scaleDiff:CGFloat = 0
    var scaleThresholdPassed = false
    var roll:CGFloat = 0
    var rollDiff:CGFloat = 0
    var pitch:CGFloat = 0
    var pitchDiff:CGFloat = 0
    var trackingThreeFingerPan = false
    
    // Reset gesture transform state
    func resetGestureTransformState() {
        state = 0
        x = -1
        y = -1
        rotation = 0
        rotationDiff = 0
        rotationThresholdPassed = false
        scale = 1
        scaleDiff = 0
        scaleThresholdPassed = false
        roll = 0
        rollDiff = 0
        trackingThreeFingerPan = false
    }
    
    // Allow multiple gestures to be recognized simultaneously
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // Don't recognize gestures if pressing buttons
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view!.isKind(of: UIControl.self)) {
            return false
        } else {
            return true
        }
    }
    
    // Process gesture as rotation if possible
    func processAsRotation(gestureRecognizer: UIGestureRecognizer) {
        
        // If gesture can be recognized as rotation
        if let rotateRecognizer = gestureRecognizer as? UIRotationGestureRecognizer {
            
            // Save new rotation locally
            let myRotation = rotateRecognizer.rotation
            
            // If new rotation crosses threshold, or if threshold is already passed
            if (myRotation < -0.01 || myRotation > 0.01 || rotationThresholdPassed) {
                
                // Update gesture transform state
                rotationDiff = myRotation - rotation
                rotation = myRotation
                rotationThresholdPassed = true
                
                // Save new x and y locally
                let myX = rotateRecognizer.location(in: self.view).x
                let myY = rotateRecognizer.location(in: self.view).y
                
                // Update gesture transform state if less than 25px distance (prevent jumpiness)
                let hypothenuse = sqrt(pow((x - myX), 2) + pow((y - myY),2))
                if hypothenuse < 25 {
                    x = myX
                    y = myY
                }
            }
            
            printGestureTranform(sender: "rotate")
        }
    }
    
    // Process gesture as pinch if possible
    func processAsPinch(gestureRecognizer: UIGestureRecognizer) {
        
        // If gesture can be recognized as pinch
        if let pinchRecognizer = gestureRecognizer as? UIPinchGestureRecognizer {
            
            // Save new scale locally
            let myScale = pinchRecognizer.scale
            
            // If new rotation crosses theshold, or if threshold is already passed
            if (myScale <= 0.9 || myScale >= 1.1 || scaleThresholdPassed) {
                
                // Update gesture transform state
                scaleDiff = myScale - scale
                scale = myScale
                scaleThresholdPassed = true
                
                // Save new x and y locally
                let myX = pinchRecognizer.location(in: self.view).x
                let myY = pinchRecognizer.location(in: self.view).y
                
                // Update gesture transform state if less than 25px distance (prevent jumpiness)
                let hypothenuse = sqrt(pow((x - myX), 2) + pow((y - myY),2))
                if hypothenuse < 25 {
                    x = myX
                    y = myY
                }
            }
            printGestureTranform(sender: "pinch")
        }
    }
    
    // Process gesture as pan if possible
    func processAsPan(gestureRecognizer: UIGestureRecognizer) {
        
        // If gesture can be recognized as pan
        if let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            
            // Save new x and y locally
            let myX = panRecognizer.location(in: self.view).x
            let myY = panRecognizer.location(in: self.view).y
            
            // Set x and y if not yet set
            if (x == -1) {
                x = myX
            }
            
            if (y == -1) {
                y = myY
            }
            
            // Update gesture transform state if less than 25px distance (prevent jumpiness)
            if (x != -1 && y != -1) {
                let hypothenuse = sqrt(pow((x - myX), 2) + pow((y - myY),2))
                if hypothenuse < 25 {
                    x = myX
                    y = myY
                }
            }
            printGestureTranform(sender: "pan")
        }
    }
    
    func processAsThreeFingerPan(gestureRecognizer: UIGestureRecognizer) {
        if let threeFingerPanRecognizer = gestureRecognizer as? ThreeFingerPan {
            if (!trackingThreeFingerPan && threeFingerPanRecognizer.state == .changed) {
                trackingThreeFingerPan = true
            }
            
            let myRoll = threeFingerPanRecognizer.offsetX
            rollDiff = myRoll - roll
            roll = myRoll
            
            let myPitch = threeFingerPanRecognizer.offsetY
            pitchDiff = myPitch - pitch
            pitch = myPitch
            
            rotation = 0
            rotationDiff = 0
            scale = 1
            scaleDiff = 0
            
            printGestureTranform(sender: "three finger pan")
        }
    }
    
    @IBAction func processTransform(_ sender: Any) {
        let gesture = sender as! UIGestureRecognizer
        
        switch gesture.state {
            
            case .began:
                
                // Reset gesture transform state if previous gestures cleaned up
                if gestures.count == 0 {
                    resetGestureTransformState()
                }
                
                // Don't set x and y on three finger pan begin
                if (gesture.numberOfTouches < 3) {
                    x = gesture.location(in: self.view).x
                    y = gesture.location(in: self.view).y
                }
                
                // Set current gesture as active
                gestures.insert(gesture)
            
            case .changed:
                
                // Save state as changed
                state = 1
                
                // For current gesture(s), process as rotation, pinch, and pan if possible
                gestures.forEach({ (gesture) in

                    processAsThreeFingerPan(gestureRecognizer: gesture)
                    // Three finger pan should block other gestures3
                    if (!trackingThreeFingerPan) {
                        processAsRotation(gestureRecognizer: gesture)
                        processAsPinch(gestureRecognizer: gesture)
                        processAsPan(gestureRecognizer: gesture)
                    }
                })

            case .ended:
                
                // Save state as ended
                state = 2
                trackingThreeFingerPan = false
                
                // Clean up gesture from active gesture list
                gestures.remove(gesture)
            
            default:
                break
        }
        
        // Create and send OSC message with gesture state
        let message = OSCMessage(address, state, Int(x), Int(y), Float(rollDiff), Float(pitchDiff), Float(rotationDiff), Float(scaleDiff))
        client.send(message)
    }
    
    func printGestureTranform(sender: String){
        let stateString = " state: " + String(state)
        let xString = " x: " + String(Int(x))
        let yString = " y: " + String(Int(y))
        let rotationString = " rotation: " + String(Float(rotationDiff))
        let scaleString = " scale: " + String(Float(scaleDiff))
        let rollString = " roll: " + String(Float(rollDiff))
        let pitchString = " pitch: " + String(Float(pitchDiff))
        print(stateString + xString + yString + rotationString + scaleString + rollString + pitchString + " from " + sender)
    }
    
    // Create a popup with textfield to set client IP address
    @IBAction func changeClientIP(sender: UIButton) {
        var ipAddressField: UITextField?
        var portField: UITextField?
        
        // Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Set Client IP Address", message: "Set the IP address of the client running UnrealSketching.", preferredStyle: .alert)
        
        // Create and add cancel button
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheetController.addAction(cancelAction)
        
        // Create and add set button
        let setAction: UIAlertAction = UIAlertAction(title: "Set", style: .default) { action -> Void in
            
            // Unwrap IP address field and if not empty string, set IP address
            if let unwrappedIPAddressField = ipAddressField {
                if unwrappedIPAddressField.text! != "" {
                    self.ipaddress = unwrappedIPAddressField.text!
                }
            }
            
            // Unwrap port field and if castable to Int, set port
            if let unwrappedPortField = portField {
                if let port = Int(unwrappedPortField.text!) {
                    self.port = port
                }
            }
            
            // Update client with new address and/or port
            self.client = OSCClient(address: self.ipaddress, port: self.port)
        }
        actionSheetController.addAction(setAction)
        
        //Add IP address field
        actionSheetController.addTextField { (textField) in
            textField.placeholder = "Address: " + self.ipaddress
            ipAddressField = textField
        }
        
        //Add port field
        actionSheetController.addTextField { (textField) in
            textField.placeholder = "Port: " + String(self.port)
            portField = textField
        }
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
}

