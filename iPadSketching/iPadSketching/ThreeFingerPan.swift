//
//  CustomGestureRecognizer.swift
//  iPadSketching
//
//  Created by Daniel Roeven on 04/05/2018.
//  Copyright © 2018 Daniel Roeven. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

public class ThreeFingerPan: UIGestureRecognizer {
    
    open var roll:CGFloat = 0.0
    var startX:CGFloat = -1
    var startY:CGFloat = -1
    var beganTracking = false
    var touchesBeingTracked:Set<UITouch> = Set<UITouch>(minimumCapacity: 3)
    
    override public func reset() {
        super.reset()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        
        if (!beganTracking) {
            touchesBeingTracked = Set<UITouch>(minimumCapacity: 3)
            beganTracking = true
        }

        for touch in touches {
            if (touchesBeingTracked.count < 3) {
                touchesBeingTracked.insert(touch)
            }
            else {
                self.ignore(touch, for: event)
            }
        }
        
        if (touchesBeingTracked.count == 3) {
            state = .began
            
            // Calculate average position over taps
            var averageX:CGFloat = 0
            var averageY:CGFloat = 0
            for touch in touches {
                averageX += touch.location(in: self.view).x
                averageY += touch.location(in: self.view).y
            }
            averageX /= CGFloat(touches.count)
            averageY /= CGFloat(touches.count)
            
            // Set start x, y, and roll
            startX = averageX
            startY = averageY
            roll = 0.0
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {

        // Gesture is meaningful if three or more fingers
        if (touchesBeingTracked.count >= 3) {

            // Calculate average position
            var averageX:CGFloat = 0
            var averageY:CGFloat = 0
            for touch in touches {
                averageX += touch.location(in: self.view).x
                averageY += touch.location(in: self.view).y
            }
            averageX /= CGFloat(touches.count)
            averageY /= CGFloat(touches.count)

            // Calculate distance moved since last change
            let diffX = averageX - startX
            let diffY = averageY - startY
            var hypothenuse = sqrt(pow(diffX, 2) + pow(diffY, 2))
            if (diffX < 0) {
                hypothenuse *= -1
            }

            // Set roll to hypothenuse
            roll = hypothenuse
            
            state = .changed
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        touchesBeingTracked.subtract(touches)
        
        if (touchesBeingTracked.count == 0) {
            state = .ended
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        touchesBeingTracked.subtract(touches)
        state = .cancelled
    }
}
