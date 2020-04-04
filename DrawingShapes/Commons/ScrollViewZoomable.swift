//
//  ScrollViewZoomable.swift
//  DrawingShapes
//
//  Created by Eddie on 4/4/20.
//  Copyright © 2020 Eddie. All rights reserved.
//

import UIKit

class ScrollViewZoomable : UIView, UIScrollViewDelegate {
    var retainScaleViews: [UIView] { fatalError("Must implemented in subclass") }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? { return self }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let invert = transform.inverted()
        retainScaleViews.forEach { $0.transform = invert }
    }
}
