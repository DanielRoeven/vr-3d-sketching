//
//  ViewController.swift
//  iPadSketching
//
//  Created by Daniel Roeven on 21/04/2018.
//  Copyright © 2018 Daniel Roeven. All rights reserved.
//

import UIKit
import SwiftOSC

class ViewController: UIViewController {

    var ipaddress = "192.168.0.1"
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

    // Handle pan gesture and send OSC message.
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        let x = sender.location(in: self.view).x
        let y = sender.location(in: self.view).y
        let message = OSCMessage(address, String("Pan"), Int(x), Int(y))
        client.send(message)
        print("Pan: (" + String(Int(x)) + ", " + String(Int(y)) + ")")
    }
    
    @IBAction func handleRotate(sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        let x = sender.location(in: self.view).x
        let y = sender.location(in: self.view).y
        let message = OSCMessage(address, String("Rotate"), Float(rotation), Int(x), Int(y))
        client.send(message)
        print("Rotation: " + String(Float(rotation)))
    }
    
    @IBAction func handlePinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let x = sender.location(in: self.view).x
        let y = sender.location(in: self.view).y
        let message = OSCMessage(address, String("Pinch"), Float(scale), Int(x), Int(y))
        client.send(message)
        print("Pinch: " + String(Float(scale)))
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

