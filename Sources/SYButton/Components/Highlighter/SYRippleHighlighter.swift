//
//  SYRippleHighlighter.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// `SYRippleHighlighter` is a highlighter that applies a ripple effect to an `SYButton` when it is highlighted.
public class SYRippleHighlighter: NSObject, SYButtonHighlighter {
    // MARK: Properties

    /// The color of the ripple effect. The default color is white with a opacitiy of 40%.
    public var rippleColor: UIColor = .white.withAlphaComponent(0.4)

    /// The duration of the ripple animation in seconds. The default duration is 0.5 seconds.
    public var rippleDuration: CFTimeInterval = 0.5

    /// The radius of the ripple effect. If `nil`, the ripple will cover the entire button.
    public var rippleRadius: CGFloat?

    /// A Boolean value that determines whether the ripple effect tracks the touch location.
    /// If `true`, the ripple originates from the touch location; if `false`, it originates from the center of the button. The default value is `true`.
    public var trackLocation: Bool = true

    private var rippleName = "rippleLayer"

    // MARK: Init

    override public convenience init() {
        self.init(
            rippleColor: .white.withAlphaComponent(0.4),
            rippleDuration: 0.5,
            rippleRadius: nil,
            trackLocation: true
        )
    }

    /// Initializes a new instance of `SYRippleHighlighter` with the specified properties.
    ///
    /// - Parameters:
    ///   - rippleColor: The color of the ripple effect.
    ///   - rippleDuration: The duration of the ripple animation.
    ///   - rippleRadius: The radius of the ripple effect. If `nil`, the ripple will cover the entire button.
    ///   - trackLocation: A Boolean value that determines whether the ripple effect tracks the touch location.
    public init(rippleColor: UIColor, rippleDuration: CFTimeInterval, rippleRadius: CGFloat?, trackLocation: Bool) {
        self.rippleColor = rippleColor
        self.rippleDuration = rippleDuration
        self.rippleRadius = rippleRadius
        self.trackLocation = trackLocation
    }

    private var highlightedLayer: CALayer?

    // MARK: Functions

    public func highlight(_ button: SYButton, at location: CGPoint) {
        // Create the ripple layer
        let rippleSize = rippleRadius ?? max(button.frame.width, button.frame.height)
        let rippleLayer = createRipple(with: rippleSize)
        rippleLayer.position = trackLocation ? location : CGPoint(x: button.frame.width / 2, y: button.frame.height / 2)
        // initally scale it down to animate the scale
        rippleLayer.transform = CATransform3DMakeScale(0.0, 0.0, 1.0)

        // Create a mask layer to contain the ripple effect within the button's bounds
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: button.bounds, cornerRadius: button.layer.cornerRadius).cgPath
        maskLayer.frame = button.bounds

        // Add ripple layer to the maskLayer
        let containerLayer = CALayer()
        containerLayer.frame = button.bounds
        containerLayer.mask = maskLayer
        highlightedLayer = containerLayer

        containerLayer.addSublayer(rippleLayer)
        button.layer.addSublayer(containerLayer)

        let animation = createRippleAnimation()
        rippleLayer.add(animation, forKey: "rippleEffect")
    }

    public func stopHighlight(_ button: SYButton) {
        guard let ripple = highlightedLayer?.sublayers?.first(where: { $0.name == rippleName }) else { return }
        highlightedLayer = nil

        let fadeAnimation = fadingAnimation()
        // run the animation backwards
        fadeAnimation.speed = -1
        fadeAnimation.delegate = self
        ripple.add(fadeAnimation, forKey: "rippleFadeOut")
    }
}

// MARK: CAAnimationDelegate

extension SYRippleHighlighter: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let layer = anim.value(forKeyPath: "animationLayer") as? CALayer
        // remove the `highlightedLayer`
        layer?.superlayer?.removeFromSuperlayer()
    }
}

// MARK: Helper

extension SYRippleHighlighter {
    private func createRipple(with radius: CGFloat) -> CAShapeLayer {
        let rippleLayer = CAShapeLayer()
        rippleLayer.backgroundColor = rippleColor.cgColor
        rippleLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        rippleLayer.cornerRadius = radius / 2
        rippleLayer.name = rippleName
        return rippleLayer
    }

    private func createRippleAnimation() -> CAAnimation {
        // scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.fillMode = .forwards
        scaleAnimation.isRemovedOnCompletion = false

        // fade animation
        let fadeAnimation = fadingAnimation()

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, fadeAnimation]
        animationGroup.duration = rippleDuration
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false

        return animationGroup
    }

    private func fadingAnimation() -> CAAnimation {
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 1
        fadeAnimation.isRemovedOnCompletion = false
        fadeAnimation.fillMode = .forwards
        fadeAnimation.duration = rippleDuration
        return fadeAnimation
    }
}
