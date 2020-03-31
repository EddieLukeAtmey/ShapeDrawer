//
//  Shapes.swift
//  DrawingShapes
//
//  Created by Eddie on 3/31/20.
//  Copyright © 2020 Eddie. All rights reserved.
//

import Foundation

/* Input:
 Shape: Rectangular or circular.

 Rectangular: Width, Length
 Circular: Radius
 */

enum ShapeInfo: Equatable {
    case circle(radius: Int)
    case rectangle(width: Int, height: Int)

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {

        case (.circle (let lRadius),
              .circle(let rRadius)): return lRadius == rRadius

        case (.rectangle(let lWidth, let lHeight),
              .rectangle(let rWidth, let rHeight)):

            return lWidth == rWidth && lHeight == rHeight

        default:
            return false
        }
    }
}

//struct ShapeDescription: Equatable {
//
//    var type: ShapeType
//    var radius: Int = 0
//    var width: Int = 0
//    var height: Int = 0
//}
