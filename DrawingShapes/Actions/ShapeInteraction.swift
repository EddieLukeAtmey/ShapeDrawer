//
//  ShapeInteraction.swift
//  DrawingShapes
//
//  Created by Eddie on 3/31/20.
//  Copyright © 2020 Eddie. All rights reserved.
//

import UIKit

protocol PinViewProtocol: UIView {
}

protocol AddPinViewHandlerDelegate: class {

    func pinViewHandler(_ : AddPinViewHandler, didTap pin: PinViewProtocol)
    func pinViewHandler(_ : AddPinViewHandler, didAdd pin: PinViewProtocol)
}

final class AddPinViewHandler: NSObject, UIGestureRecognizerDelegate {

    private let pinSize = CGSize(width: 25, height: 25)
    private var pinViews: [PinViewProtocol] { view.subviews.lazy.compactMap { $0 as? PinViewProtocol }  }
    private weak var view: UIView!
    private weak var delegate: AddPinViewHandlerDelegate!
//    private weak var tapGesture: UITapGestureRecognizer?

    init(view: UIView, delegate: AddPinViewHandlerDelegate) {
        super.init()

        self.view = view
        self.delegate = delegate

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
//        self.tapGesture = tapGesture
    }

    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        let loc = gesture.location(ofTouch: 0, in: gesture.view)

        // If existed, call out
        if let view = gesture.view?.hitTest(loc, with: nil) as? PinViewProtocol {
            delegate.pinViewHandler(self, didTap: view)
            return
        }

        addPin(at: loc)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    /// Add pin view to a location
    private func addPin(at location: CGPoint) {
        var rect = CGRect.zero
        rect.origin = CGPoint(x: location.x - (pinSize.width / 2), y: location.y - (pinSize.height / 2))
        rect.size = pinSize

        let pinView = PinView(frame: rect)
        view.addSubview(pinView)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        pinView.addGestureRecognizer(panGesture)

        delegate.pinViewHandler(self, didAdd: pinView)
    }

    // Move Item
    private var viewLocation: CGPoint?
    @objc private func drag(_ gesture: UIPanGestureRecognizer) {

        switch gesture.state {
        case .began: viewLocation = gesture.view?.center
        case .ended, .cancelled, .failed:
            defer { viewLocation = nil }

            if pinViews.first(where: { $0 !== gesture.view && $0.frame.intersects(gesture.view!.frame) }) != nil,
                let viewLocation = viewLocation {
                // Reset view
                gesture.view?.center = viewLocation
            }

        case .changed where viewLocation != nil:

            let translation = gesture.translation(in: view)
            gesture.view?.center = CGPoint(x: viewLocation!.x + translation.x, y: viewLocation!.y + translation.y)

        default:
            viewLocation = nil
        }
    }
}

final class PinView: UIView, PinViewProtocol {

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .systemRed
        layer.cornerRadius = bounds.width / 2
    }
}
