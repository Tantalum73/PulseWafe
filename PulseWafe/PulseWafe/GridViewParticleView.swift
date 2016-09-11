//
//  GridViewParticleView.swift
//  PulsewafeTest
//
//  Created by Andreas Neusüß on 19.08.16.
//  Copyright © 2016 Anerma. All rights reserved.
//

import UIKit

class GridViewParticleView: UIView {
    
    init () {
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let color = UIColor.black.withAlphaComponent(0.5)
        color.setStroke()
        
        let gap : CGFloat = 0.0
        let lineWidth : CGFloat = 1.0
        
        let topCenter = CGPoint(x: bounds.midX, y: bounds.origin.y + gap)
        let rightCenter = CGPoint(x: bounds.width - gap, y: bounds.midY)
        let bottomCenter = CGPoint(x: bounds.midX, y: bounds.height - gap)
        let leftCenter = CGPoint(x: bounds.origin.x + gap, y: bounds.midY)
        
        let topThirdLeft = CGPoint(x: bounds.width * 0.2, y: bounds.origin.y + gap)
        let bottomThirdLeft = CGPoint(x: topThirdLeft.x, y: bounds.height - gap)
        let topThirdRight = CGPoint(x: bounds.width - topThirdLeft.x, y: bounds.origin.y + gap)
        let bottomThirdRight = CGPoint(x: topThirdRight.x, y: bounds.height - gap)
        
//        let center = convert(self.center, to: self)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
//        let context = UIGraphicsGetCurrentContext()
//        let rect = CGRect(x: bounds.origin.x + lineWidth, y: bounds.origin.y + lineWidth, width: bounds.width - (2 * lineWidth), height: bounds.height - (2 * lineWidth))
        
        let rotatedRectPath = UIBezierPath()
        rotatedRectPath.move(to: topCenter)
        rotatedRectPath.addLine(to: rightCenter)
        rotatedRectPath.addLine(to: bottomCenter)
        rotatedRectPath.addLine(to: leftCenter)
        rotatedRectPath.addLine(to: topCenter)
        rotatedRectPath.lineWidth = lineWidth
        rotatedRectPath.stroke()
        
        
        let verticalLineLeft = UIBezierPath()
        verticalLineLeft.move(to: topThirdLeft)
        verticalLineLeft.addLine(to: center)
        verticalLineLeft.addLine(to: bottomThirdLeft)
        verticalLineLeft.lineWidth = lineWidth
        verticalLineLeft.stroke()
        
        let verticalLineRight = UIBezierPath()
        verticalLineRight.move(to: topThirdRight)
        verticalLineRight.addLine(to: center)
        verticalLineRight.addLine(to: bottomThirdRight)
        verticalLineRight.lineWidth = lineWidth
        verticalLineRight.stroke()
        
//        context?.setStrokeColor(UIColor.red.cgColor)
        
        //context?.stroke(rect)
    }
    static let rippleAnimationKeyTimes : [NSNumber] = [0, 0.1, 0.61, 0.7, 1]//[0, 0.61, 0.7, 0.887, 1]

    func animateView(withDuration duration: TimeInterval, particleDelay: TimeInterval, particleDirection: CGPoint, onlyOnce : Bool = false) {
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0, 0.2, 1)
        let linearFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        let easeOutFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        let easeInOutTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        let zeroPointValue = NSValue(cgPoint: CGPoint.zero)
        
        var animations = [CAAnimation]()
        
            // Transform.scale
            let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            scaleAnimation.values = [1, 1.05, 1, 1, 1]//[1, 1, 1.05, 1, 1] //more for more depth
            scaleAnimation.keyTimes = GridViewParticleView.rippleAnimationKeyTimes
            scaleAnimation.timingFunctions = [linearFunction, timingFunction, timingFunction, linearFunction]
            scaleAnimation.beginTime = 0.0
            scaleAnimation.duration = duration
            animations.append(scaleAnimation)
            
            // Position
            let positionAnimation = CAKeyframeAnimation(keyPath: "position")
            positionAnimation.duration = duration/3.0
           positionAnimation.timingFunctions = [timingFunction, timingFunction, timingFunction]
            positionAnimation.keyTimes = GridViewParticleView.rippleAnimationKeyTimes
            positionAnimation.values = [zeroPointValue, NSValue(cgPoint:particleDirection), zeroPointValue, zeroPointValue]
            positionAnimation.isAdditive = true
            
            animations.append(positionAnimation)
        
        
        // Opacity
        let  opacityStart = layer.presentation()?.opacity ?? 0
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = duration
        opacityAnimation.timingFunctions = [linearFunction, easeOutFunction]
        opacityAnimation.keyTimes = [0.0, 0.1, 1.0]
        opacityAnimation.values = [opacityStart, 1, 0.0]//[0.0, 1.0, 0.45, 0.6, 0.0, 0.0]
        animations.append(opacityAnimation)
        
        // Group
        let groupAnimation = CAAnimationGroup()
        groupAnimation.repeatCount = onlyOnce ? 1 : Float.infinity
        groupAnimation.fillMode = kCAFillModeBoth
        groupAnimation.duration = duration
        groupAnimation.beginTime = CACurrentMediaTime() + particleDelay
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.animations = animations
        /// The offset between the AnimatedULogoView and the background Grid
//        groupAnimation.timeOffset = kAnimationTimeOffset
        
        layer.add(groupAnimation, forKey: "pulse")
   
    }

}
