//
//  CustomCheckmarkView.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 11.09.2024.
//

import Foundation
import UIKit

// MARK: - CustomCheckmarkView

class CustomCheckmarkView: UIView {
    
    private let checkmarkLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        checkmarkLayer.strokeColor = UIColor.systemBlue.cgColor
        checkmarkLayer.lineWidth = 2
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(checkmarkLayer)
    }
    
    func setChecked(_ checked: Bool) {
        checkmarkLayer.path = checked ? createCheckmarkPath().cgPath : nil
    }
    
    private func createCheckmarkPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 5, y: bounds.height / 2))
        path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height - 5))
        path.addLine(to: CGPoint(x: bounds.width - 5, y: 5))
        return path
    }
}
