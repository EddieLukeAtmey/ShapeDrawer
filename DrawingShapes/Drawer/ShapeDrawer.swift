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

        // Magic here: draw with level
        let rectView = RectangleView(size: CGSize(width: width, height: height), level: 4)
        rectView.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2)
        view.addSubview(rectView)
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
}

final class RectangleView: UIView {

    var rectSize = CGSize.zero
    var shapeColor = UIColor.clear

    convenience init(size: CGSize, level: Int) {

        self.init(frame: CGRect(origin: .zero, size: size))

        var innerSize = size
        innerSize.width = size.width - (size.width / CGFloat(level))
        innerSize.height = size.height - (size.height / CGFloat(level))

        self.rectSize = innerSize
        backgroundColor = .clear
        shapeColor = .systemGreen

        if level > 1 {
            let rectView = RectangleView(size: innerSize, level: level - 1)
            rectView.center = CGPoint(x: size.width / 2, y: size.height / 2)
            addSubview(rectView)
            shapeColor = rectView.shapeColor.withAlphaComponent(1 - (1 / CGFloat(level)))
        }
    }

    override func draw(_ rect: CGRect) {

        let point = CGPoint(x: (rect.size.width - rectSize.width) / 2,
                            y: (rect.size.height - rectSize.height) / 2)

        let rectPath = UIBezierPath(rect: CGRect(origin: point, size: rectSize))
        rectPath.lineWidth = 2

        UIColor.black.setStroke()
        rectPath.stroke()

        shapeColor.setFill()
        rectPath.fill()
    }
}
