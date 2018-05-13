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
    
    open var offsetX:CGFloat = 0.0
    open var offsetY:CGFloat = 0.0
    open var lastFingerOffset:CGFloat = 0.0
    var startX:CGFloat = -1
    var startY:CGFloat = -1
    var beganTracking = false
    var touchesBeingTracked:Set<UITouch> = Set<UITouch>(minimumCapacity: 3)
    var firstTouch:UITouch?
    var secondTouch:UITouch?
    var thirdTouch:UITouch?
    var zTranslateMode = false
    var rollMode = true
    
    override public func reset() {
        super.reset()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        
        if (!beganTracking) {
            touchesBeingTracked = Set<UITouch>(minimumCapacity: 3)
            beganTracking = true
        }

        for touch in touches {
            if (touchesBeingTracked.count == 0) {
                touchesBeingTracked.insert(touch)
                firstTouch = touch
            }
            else if (touchesBeingTracked.count == 1) {
                touchesBeingTracked.insert(touch)
                secondTouch = touch
            }
            else if (touchesBeingTracked.count == 2) {
                zTranslateMode = false
                rollMode = false
                touchesBeingTracked.insert(touch)
                thirdTouch = touch
            }
            else {
                self.ignore(touch, for: event)
            }
        }
        
        if (touchesBeingTracked.count == 3) {
            state = .began
            
            // Calculate average position
            var totalAverageX:CGFloat = 0
            var totalAverageY:CGFloat = 0
            for touch in touchesBeingTracked {
                totalAverageX += touch.location(in: self.view).x
                totalAverageY += touch.location(in: self.view).y
            }
            totalAverageX /= CGFloat(touchesBeingTracked.count)
            totalAverageY /= CGFloat(touchesBeingTracked.count)
            
            let firstTwoAverageX:CGFloat = (firstTouch!.location(in: self.view).x + secondTouch!.location(in: self.view).x)/2
            let firstTwoAverageY:CGFloat = (firstTouch!.location(in: self.view).y + secondTouch!.location(in: self.view).y)/2
            
            let distLastTouchToFirstTwo = hypothenuse(x1: thirdTouch!.location(in: self.view).x,
                                                      x2: firstTwoAverageX,
                                                      y1: thirdTouch!.location(in: self.view).y,
                                                      y2: firstTwoAverageY)

            if (distLastTouchToFirstTwo > 280) {
                zTranslateMode = true
            } else if (distLastTouchToFirstTwo < 180) {
                rollMode = true
            }
            
            // Set start x, y, and roll
            startX = totalAverageX
            startY = totalAverageX
            offsetX = 0.0
            offsetY = 0.0
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {

        // Gesture is meaningful if three or more fingers
        if (touchesBeingTracked.count >= 3) {
            
            // Calculate average position
            var totalAverageX:CGFloat = 0
            var totalAverageY:CGFloat = 0
            for touch in touchesBeingTracked {
                totalAverageX += touch.location(in: self.view).x
                totalAverageY += touch.location(in: self.view).y
            }
            totalAverageX /= CGFloat(touchesBeingTracked.count)
            totalAverageY /= CGFloat(touchesBeingTracked.count)
            
            let firstTwoAverageX:CGFloat = (firstTouch!.location(in: self.view).x + secondTouch!.location(in: self.view).x)/2
            let firstTwoAverageY:CGFloat = (firstTouch!.location(in: self.view).y + secondTouch!.location(in: self.view).y)/2
            
            let distLastTouchToFirstTwo = hypothenuse(x1: thirdTouch!.location(in: self.view).x,
                                                      x2: firstTwoAverageX,
                                                      y1: thirdTouch!.location(in: self.view).y,
                                                      y2: firstTwoAverageY)
            
            if (zTranslateMode) {
                lastFingerOffset = distLastTouchToFirstTwo
                state = .changed
            }
            else if (rollMode) {
                // Calculate distance moved since last change
                offsetX = totalAverageX - startX
                offsetY = totalAverageY - startY
                lastFingerOffset = 0
                state = .changed
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        touchesBeingTracked.subtract(touches)
        //print(touchesBeingTracked.count)
        if (touchesBeingTracked.count == 0) {
            state = .ended
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        touchesBeingTracked.subtract(touches)
        state = .cancelled
    }
    
    func hypothenuse(x1:CGFloat, x2:CGFloat, y1:CGFloat, y2:CGFloat) -> CGFloat {
        return sqrt(pow((x1 - x2), 2) + pow((y1 - y2),2))
    }
}
