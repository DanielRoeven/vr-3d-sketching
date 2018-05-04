//
//  CustomGestureRecognizer.swift
//  iPadSketching
//
//  Created by Daniel Roeven on 04/05/2018.
//  Copyright © 2018 Daniel Roeven. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

public class CustomGestureRecognizer: UIGestureRecognizer {
    override public func reset() {
        super.reset()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        print("touches began")
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        print("touches moved")
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        print("touches ended")
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        print("touches cancelled")
    }
}
