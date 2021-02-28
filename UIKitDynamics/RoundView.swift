//
//  RoundView.swift
//  UIKitDynamics
//
//  Created by Metah on 21.02.2021.
//

import UIKit

class CircleView: UIImageView {
    var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.addSublayer(shapeLayer)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.path = circularPath(center: center).cgPath
    }

    private func circularPath(center: CGPoint = .zero) -> UIBezierPath {
        let radius = min(bounds.width, bounds.height) / 2
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
    }

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType { return .path }

    override var collisionBoundingPath: UIBezierPath { return circularPath()
    }
}
