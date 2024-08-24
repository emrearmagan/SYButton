//
//  SYBallPulseIndicator.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

open class SYBallPulseIndicator: UIView, SYLoadingIndicator {
    // MARK: Properties

    /// Array containing the balls `CAShapeLayer` responsible animations.
    private var indicators: [CAShapeLayer] = []
    /// Private flag for the animation state
    private var _isAnimating = false
    /// Spacing between each indicator
    private let spacing = 2.0
    /// Number of indicator to show
    private let indicatorCount = 3
    /// begin times for each indicator
    private let beginTimes = [0.35, 0, 0.35]

    public var isAnimating: Bool {
        return _isAnimating
    }

    public var indicatorColor: UIColor = .white {
        didSet {
            indicators.forEach { $0.fillColor = indicatorColor.cgColor }
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

    override public func layoutSubviews() {
        super.layoutSubviews()

        let numberOfSpacers = CGFloat(indicatorCount - 1)
        let circleWidth = (frame.width - spacing * numberOfSpacers) / CGFloat(indicatorCount)
        let circleSize = CGSize(width: circleWidth, height: circleWidth)

        for (index, indicator) in indicators.enumerated() {
            let x = (circleWidth + spacing) * CGFloat(index)
            let path = createCirclePath(with: circleSize)
            let frame = CGRect(origin: CGPoint(x: x, y: (frame.height - circleSize.height) / 2.0), size: circleSize)
            indicator.path = path.cgPath
            indicator.frame = frame
        }
    }

    private func setupUI() {
        for _ in 0 ..< indicatorCount {
            let indicator = CAShapeLayer()
            indicator.fillColor = indicatorColor.cgColor
            layer.addSublayer(indicator)
            indicators.append(indicator)
        }
    }

    /// Starts the scale animation on all three balls.
    open func startAnimating() {
        _isAnimating = true
        indicators.forEach { $0.isHidden = false }
        let animationDuration = 0.6

        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.keyTimes = [0, 0.5, 1]
        opacityAnimation.values = [1, 0.2, 1]
        opacityAnimation.duration = animationDuration

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 0.3
        scaleAnimation.duration = animationDuration
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [opacityAnimation, scaleAnimation]
        animationGroup.timingFunction = CAMediaTimingFunction(name: .linear)
        animationGroup.duration = animationDuration
        scaleAnimation.repeatCount = .infinity
        animationGroup.isRemovedOnCompletion = false

        // Start the animation with a slight delay between each ball
        for (index, indicator) in indicators.enumerated() {
            scaleAnimation.beginTime = CACurrentMediaTime() + Double(index) * 0.2
            indicator.add(scaleAnimation, forKey: "scale")
        }
    }

    /// Stops the spinner animation and hides the `circularLayer`.
    open func stopAnimating() {
        _isAnimating = false
        indicators.forEach { $0.isHidden = true }
        indicators.forEach { $0.removeAllAnimations() }
    }

    private func createCirclePath(with size: CGSize) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 2

        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: 2 * Double.pi,
                    clockwise: false
        )
        return path
    }
}
