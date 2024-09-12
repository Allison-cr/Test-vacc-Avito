//
//  UIView+.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//

import UIKit

// Loading animation for stubView

extension UIImageView {
    
    func startLoadingAnimation(width: CGFloat) {
        
        stopLoadingAnimation()
        
        let numberOfLines = 7
        let lineWidth: CGFloat = width
            
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        let maskPath = UIBezierPath(rect: self.bounds)
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
        for i in 0..<numberOfLines {
            let lineLayer = CAShapeLayer()
            lineLayer.strokeColor = UIColor.white.cgColor
            lineLayer.lineWidth = lineWidth
            lineLayer.opacity = 0.7 - Float(abs(i - 3)) / Float(numberOfLines)
            let delta = CGFloat(i) * lineWidth
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: self.bounds.height, y: self.bounds.height))
            
            lineLayer.path = path.cgPath
            self.layer.addSublayer(lineLayer)
            
            let perpendicularPath = UIBezierPath()
            perpendicularPath.move(to: CGPoint(x: -self.bounds.width + delta, y: 0))
            perpendicularPath.addLine(to: CGPoint(x: self.bounds.width + delta, y: 0))
            
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.path = perpendicularPath.cgPath
            animation.duration = 2.0
            animation.repeatCount = .infinity
            
            lineLayer.add(animation, forKey: "lineMovement")
        }
    }
    
    func stopLoadingAnimation() {
        self.layer.sublayers?.forEach { layer in
            if let shapeLayer = layer as? CAShapeLayer {
                shapeLayer.removeFromSuperlayer()
            }
        }
        self.layer.mask = nil
    }
}
