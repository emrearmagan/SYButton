//
//  SYLoadingSpinner.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation

//
//  SYLoadingSpinner.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import UIKit

/// `SYLoadingSpinner` is a custom loading indicator view that displays a circular spinner using `CAShapeLayer`.
open class SYLoadingSpinner: UIView, SYLoadingIndicator {
    // MARK: Properties

    /// A `CAShapeLayer` responsible for the animation
    private let circularLayer = CAShapeLayer()

    /// Private flag for the animation state
    private var _isAnimating = false

    public var isAnimating: Bool {
        return _isAnimating
    }

    public var indicatorColor: UIColor = .white {
        didSet {
            circularLayer.strokeColor = indicatorColor.cgColor
        }
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }

    // MARK: Init

    convenience init(color: UIColor) {
        self.init(frame: .zero)
        self.indicatorColor = color
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    /// Initializes the spinner from data in a given unarchiver.
    /// - Parameter coder: An unarchiver object.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: Functions

    /// Sets up the UI elements, particularly configuring the `circularLayer`.
    private func setupUI() {
        circularLayer.fillColor = nil
        circularLayer.strokeColor = indicatorColor.cgColor
        circularLayer.lineWidth = 2
        circularLayer.strokeEnd = 0.4
        circularLayer.isHidden = true
        layer.addSublayer(circularLayer)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        let radius: CGFloat = (frame.height / 2) * 0.5
        circularLayer.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)

        let center = CGPoint(x: frame.height / 2, y: bounds.midY)
        let startAngle = 0 - Double.pi / 2
        let endAngle = Double.pi * 2 - Double.pi / 2

        circularLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true).cgPath
    }

    /// Starts the spinner animation, making the `circularLayer` visible and rotating it.
    open func startAnimating() {
        _isAnimating = true
        circularLayer.isHidden = false

        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = Double.pi * 2
        rotateAnimation.duration = 0.4
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        rotateAnimation.repeatCount = .infinity
        rotateAnimation.fillMode = .forwards
        rotateAnimation.isRemovedOnCompletion = false

        circularLayer.add(rotateAnimation, forKey: "rotation")
    }

    /// Stops the spinner animation and hides the `circularLayer`.
    open func stopAnimating() {
        _isAnimating = false
        circularLayer.isHidden = true
        circularLayer.removeAllAnimations()
    }
}
