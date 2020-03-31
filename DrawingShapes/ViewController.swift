//
//  ViewController.swift
//  DrawingShapes
//
//  Created by Eddie on 3/31/20.
//  Copyright © 2020 Eddie. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    /// Zoomable
    @IBOutlet private weak var vShapeContainer: UIView!
    @IBOutlet private weak var vShapeDisplay: UIView!
    private lazy var shapeDrawer = ShapeDrawer(view: vShapeDisplay)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func drawRectangle() {
        shapeDrawer.shape = .rectangle(width: 100, height: 75)
    }

    @IBAction private func drawCircle() {
        shapeDrawer.shape = .circle(radius: 50)
    }
}

// MARK: - ScrollView Zooming
extension ViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return vShapeContainer
    }
}

// MARK: - Rotation Gesture Delegates
extension ViewController: UIGestureRecognizerDelegate {

    @IBAction private func rotateShape(_ gesture: UIRotationGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            gesture.view?.transform = gesture.view!.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
