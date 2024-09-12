//
//  Ext+color.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 11.09.2024.
//
import UIKit

final class BlackAndWhiteCircleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {   
        let path = UIBezierPath(ovalIn: rect)
        UIColor.black.setFill()
        path.addClip()
        
        let leftRect = CGRect(x: 0, y: 0, width: bounds.width / 2, height: bounds.height)
        let rightRect = CGRect(x: bounds.width / 2, y: 0, width: bounds.width / 2, height: bounds.height)
        
        let leftPath = UIBezierPath(rect: leftRect)
        UIColor.white.setFill()
        leftPath.fill()
        
        let rightPath = UIBezierPath(rect: rightRect)
        UIColor.black.setFill()
        rightPath.fill()
        
        path.append(leftPath)
        path.append(rightPath)
    }
}
