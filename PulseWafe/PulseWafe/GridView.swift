//
//  GridView.swift
//  PulsewafeTest
//
//  Created by Andreas Neusüß on 19.08.16.
//  Copyright © 2016 Anerma. All rights reserved.
//

import UIKit

class GridView: UIView {
    
    private var particleViews = [[GridViewParticleView]]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        particleViews = constructParticleViews()
        add(particleViews: particleViews, toView: self)
        layoutIfNeeded()
    }
    
    let kRippleMagnitudeMultiplier : CGFloat = 0.025
    let kAnimationDuration : TimeInterval = 3.0
    let kRippleDelayMultiplier: TimeInterval = 0.0007666
    
    public func startAnimating() {
        pulseViews(at: center, onlyOnce: false)
    }
    public func stopAnimating() {
        
    }
    public func pulseOnce(at point: CGPoint) {
        pulseViews(at: point, onlyOnce: true)
    }
    
    fileprivate func pulseViews(at point: CGPoint, onlyOnce: Bool) {
        
        applyToAll(particleViews: particleViews) { (particleView) in
            let distance = point.distance(toPoint: particleView.center)
            var vector = point.normalizedVector(toPoint: particleView.center)
            
            //pulse is constructed by scale and transform at the same time + delay the more the view is distant from the center.
            //vector defines the translation of the view
            vector = CGPoint(x: vector.x * distance * self.kRippleMagnitudeMultiplier, y: vector.y * distance * self.kRippleMagnitudeMultiplier)
            
            particleView.animateView(withDuration: self.kAnimationDuration, particleDelay: TimeInterval(distance) * self.kRippleDelayMultiplier, particleDirection: vector, onlyOnce: onlyOnce)
        }

    }
    
    fileprivate func constructParticleViews() -> [[GridViewParticleView]] {
        let widthOfView = frame.width
        let heightOfView = frame.height
        
        let widthOfParticle : CGFloat = 100.0
        let heightOfParticle : CGFloat = 100.0
        
        let numberOfColumns = Int(ceil((widthOfView / widthOfParticle)))
        let numberOfRows = Int(ceil((heightOfView / heightOfParticle)))
        
        //stores array of rows (called columns) and will be returned.
        var particleViews = [[GridViewParticleView]]()
        
        for y in 0..<numberOfRows {
            //stores one row of the grid
            var particleRow = [GridViewParticleView]()
            
            for x in 0..<numberOfColumns {
                let view = GridViewParticleView()
                let gap : CGFloat = 0.0
                view.frame = CGRect(x: CGFloat(x) * widthOfParticle , y: CGFloat(y) * heightOfParticle, width: widthOfParticle - gap, height: heightOfParticle - gap)
                
                particleRow.append(view)
            }
            particleViews.append(particleRow)
        }
        
        return particleViews
    }
    fileprivate func add(particleViews: [[GridViewParticleView]], toView view: UIView) {
        applyToAll(particleViews: particleViews) { (particleView) in
            self.addSubview(particleView)
        }
        
    }
    
    fileprivate func applyToAll(particleViews: [[GridViewParticleView]], transformation: ((_ particleView: GridViewParticleView)->Void)) {
        
        for row in particleViews {
            for particleView in row {
                transformation(particleView)
            }
        }
    }
    
    
}

extension CGPoint {
    func distance(toPoint point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        
        return sqrt(dx * dx + dy * dy)
    }
    func normalizedVector(toPoint point: CGPoint) -> CGPoint {
        let length = distance(toPoint: point)
        
        let dx = self.x - point.x
        let dy = self.y - point.y
        
        return CGPoint(x: dx/length, y: dy/length)
    }
    func invert() -> CGPoint {
        let newPoint = CGPoint(x: -self.x, y: -self.y)
        return newPoint
    }
}
