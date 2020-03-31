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
    private var pinHandler: AddPinViewHandler!

    override func viewDidLoad() {
        super.viewDidLoad()
        pinHandler = AddPinViewHandler(view: vShapeDisplay, delegate: self)
    }

    @IBAction private func drawRectangle() {
        shapeDrawer.shape = .rectangle(width: Int(vShapeDisplay.bounds.size.width) - 20,
                                       height: Int(vShapeDisplay.bounds.size.height) - 20)
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

// MARK: - Pin Delegates
extension ViewController: AddPinViewHandlerDelegate {
    func pinViewHandler(_: AddPinViewHandler, didAdd pin: PinViewProtocol) {
    }

    func pinViewHandler(_: AddPinViewHandler, didTap pin: PinViewProtocol) {
        debugPrint(pin)
    }
}
