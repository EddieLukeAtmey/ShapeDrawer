//
//  ViewController.swift
//  DrawingShapes
//
//  Created by Eddie on 3/31/20.
//  Copyright © 2020 Eddie. All rights reserved.
//

import UIKit

final class ShapeContainerView: ScrollViewZoomable {
    override var retainScaleViews: [UIView] {
        guard let shapeDisplay = subviews.first else { return [] }
        return shapeDisplay.subviews.lazy.compactMap { $0 as? PinViewProtocol }
    }
}

final class ViewController: UIViewController {

    /// Zoomable
    @IBOutlet private weak var scrollViewContainer: UIScrollView!
    @IBOutlet private weak var vShapeContainer: ShapeContainerView!
    @IBOutlet private weak var vShapeDisplay: UIView!
    private lazy var shapeDrawer = ShapeDrawer(view: vShapeDisplay)
    private var pinHandler: AddPinViewHandler!

    // Interaction information
    private var originalRotationTransform: CGAffineTransform!

    override func viewDidLoad() {
        super.viewDidLoad()
        pinHandler = AddPinViewHandler(view: vShapeDisplay, delegate: self)
        originalRotationTransform = vShapeDisplay.transform
    }

    @IBAction private func drawRectangle() {
        shapeDrawer.shape = .rectangle(width: Int(vShapeDisplay.bounds.size.width) - 20,
                                       height: Int(vShapeDisplay.bounds.size.height) - 20)
    }

    @IBAction private func drawCircle() {
        shapeDrawer.shape = .circle(radius: 50)
    }

    @IBAction private func clearRotation() {
        UIView.animate(withDuration: 0.25) { self.vShapeDisplay.transform = self.originalRotationTransform }
    }

    @IBAction private func clearZoom() {
        scrollViewContainer.setZoomScale(0, animated: true)
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
        pin.transform = vShapeContainer.transform.inverted()
    }

    func pinViewHandler(_: AddPinViewHandler, didTap pin: PinViewProtocol) {
        debugPrint(pin)
    }
}
