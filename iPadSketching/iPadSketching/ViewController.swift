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
    
    var gestures = Set<UIGestureRecognizer>(minimumCapacity: 3)
    var x:CGFloat = -1
    var y:CGFloat = -1
    var rotation:CGFloat = 0
    var rotationDiff:CGFloat = 0
    var rotationThresholdPassed = false
    var scale:CGFloat = 1
    var scaleDiff:CGFloat = 0
    var scaleThresholdPassed = false
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func processTransform(_ sender: Any) {
        let gesture = sender as! UIGestureRecognizer
        
        switch gesture.state {
            case .began:
                if gestures.count == 0 {
                    x = -1
                    y = -1
                    rotation = 0
                    rotationThresholdPassed = false
                    scale = 1
                    scaleThresholdPassed = false
                }
                gestures.insert(gesture)
            
            case .changed:
                gestures.forEach({ (gesture) in
                    if let rotateRecognizer = gesture as? UIRotationGestureRecognizer {
                        let myRotation = rotateRecognizer.rotation
                        if (myRotation < -0.01 || myRotation > 0.01 || rotationThresholdPassed) {
                            rotationDiff = myRotation - rotation
                            rotation = myRotation
                            rotationThresholdPassed = true
                            let myX = rotateRecognizer.location(in: self.view).x
                            let myY = rotateRecognizer.location(in: self.view).y
                            let hypothenuse = sqrt(pow((x - myX), 2) + pow((y - myY),2))
                            if hypothenuse < 25 {
                                x = myX
                                y = myY
                            }
                        }
                        return
                    }
                    
                    if let pinchRecognizer = gesture as? UIPinchGestureRecognizer {
                        let myScale = pinchRecognizer.scale
                        if (myScale <= 0.9 || myScale >= 1.1 || scaleThresholdPassed) {
                            scaleDiff = myScale - scale
                            scale = myScale
                            scaleThresholdPassed = true
                            let myX = pinchRecognizer.location(in: self.view).x
                            let myY = pinchRecognizer.location(in: self.view).y
                            let hypothenuse = sqrt(pow((x - myX), 2) + pow((y - myY),2))
                            if hypothenuse < 25 {
                                x = myX
                                y = myY
                            }
                        }
                        return
                    }
                    
                    if let panRecognizer = gesture as? UIPanGestureRecognizer {
                        let myX = panRecognizer.location(in: self.view).x
                        let myY = panRecognizer.location(in: self.view).y
                        
                        // Set x and y if not yet set
                        if (x == -1) {
                            x = myX
                        }
                        if (y == -1) {
                            y = myY
                        }
                        
                        // Update x and y only if distance moved < 50 to prevent jumpiness when releasing rotate / scale
                        if (x != -1 && y != -1) {
                            let hypothenuse = sqrt(pow((x - myX), 2) + pow((y - myY),2))
                            if hypothenuse < 25 {
                                x = myX
                                y = myY
                            }
                        }
                        
                        return
                    }
                })
                print("Transform: (x: " + String(Int(x)) + ", y: " + String(Int(y)) + ", rotation: " + String(Float(rotationDiff)) + ", scale: " + String(Float(scaleDiff)) + ")")
                let message = OSCMessage(address, Int(x), Int(y), Float(rotationDiff), Float(scaleDiff))
                client.send(message)

            case .ended:
                gestures.remove(gesture)
            
            default:
                break
        }
    }

//    // Handle pan gesture and send OSC message.
//    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
//        let x = sender.location(in: self.view).x
//        let y = sender.location(in: self.view).y
//        let message = OSCMessage(address, String("Pan"), Int(x), Int(y))
//        client.send(message)
//        print("Pan: (" + String(Int(x)) + ", " + String(Int(y)) + ")")
//    }
//
//    @IBAction func handleRotate(sender: UIRotationGestureRecognizer) {
//        let rotation = sender.rotation
//        let x = sender.location(in: self.view).x
//        let y = sender.location(in: self.view).y
//        let message = OSCMessage(address, String("Rotate"), Float(rotation), Int(x), Int(y))
//        client.send(message)
//        print("Rotation: " + String(Float(rotation)))
//    }
//
//    var prevScale:Float = 1.0
//    @IBAction func handlePinch(sender: UIPinchGestureRecognizer) {
//        let scaleDiff:Float = Float(sender.scale) - prevScale
//        prevScale = Float(sender.scale)
//        let x = sender.location(in: self.view).x
//        let y = sender.location(in: self.view).y
//        let message = OSCMessage(address, String("Pinch"), scaleDiff, Int(x), Int(y))
//        client.send(message)
//        print("Pinch: " + String(scaleDiff))
//    }
    
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

