//
//  ShapeDrawer.swift
//  DrawingShapes
//
//  Created by Eddie on 3/31/20.
//  Copyright © 2020 Eddie. All rights reserved.
//

import UIKit

struct ShapeDrawer {
    weak var view: UIView!
    var shape: ShapeInfo? { didSet {
        if oldValue != shape { draw() }
    }}

    func draw() {
        view?.subviews.forEach { $0.removeFromSuperview() }
        switch shape {
        case .circle(let radius): drawCircle(radius)
        case .rectangle(let width, let height): drawRectangle(width, height)
        default: break
        }

        view?.layoutIfNeeded()
    }

    private func drawCircle(_ radius: Int) {
        view.addSubview(CircleView(radius: radius, frame: view.bounds))
    }

    private func drawRectangle(_ width: Int, _ height: Int) {
        view.addSubview(RectangleView(size: CGSize(width: width, height: height),
                                      frame: view.bounds))
    }
}

final class CircleView: UIView {
    var radius = 0
    convenience init(radius: Int, frame: CGRect) {
        self.init(frame: frame)
        self.radius = radius
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {

        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: CGFloat(radius),
                                      startAngle: 0,
                                      endAngle: CGFloat.pi * 2,
                                      clockwise: true)

        UIColor.systemBlue.set()
        circlePath.stroke()
        circlePath.fill()
    }

    override func draw(_ layer: CALayer, in ctx: CGContext) {
        super.draw(layer, in: ctx)
    }
}

final class RectangleView: UIView {

    var rectSize = CGSize.zero

    convenience init(size: CGSize, frame: CGRect) {
        self.init(frame: frame)
        self.rectSize = size
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {

        let point = CGPoint(x: (rect.size.width - rectSize.width) / 2,
                            y: (rect.size.height - rectSize.height) / 2)

        let rectPath = UIBezierPath(rect: CGRect(origin: point, size: rectSize))

        UIColor.systemGreen.set()
        rectPath.stroke()
        rectPath.fill()
    }
}
