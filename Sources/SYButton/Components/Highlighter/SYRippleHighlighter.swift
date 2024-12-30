//
//  SYRippleHighlighter.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A `SYRippleHighlighter` highlighter  applying a “ripple” effect to an `SYButton` when highlighted.
public class SYRippleHighlighter: NSObject, SYButtonHighlighter {
    // MARK: Properties

    /// The color of the ripple effect. Default is white with 40% opacity.
    public var rippleColor: UIColor

    /// The total duration (in seconds) of the ripple animation. Default is 0.5.
    public var rippleDuration: CFTimeInterval

    /// The radius of the ripple effect. If `nil`, it covers the entire button.
    public var rippleRadius: CGFloat?

    /// Whether the ripple’s origin should follow the touch location (`true`) or
    /// stay at the button center (`false`). Default is `true`.
    public var trackLocation: Bool

    private var rippleName = "rippleLayer"
    private var highlightedLayer: CALayer?

    // MARK: Init

    override public convenience init() {
        self.init(
            rippleColor: .white.withAlphaComponent(0.4),
            rippleDuration: 0.5,
            rippleRadius: nil,
            trackLocation: true
        )
    }

    /// Initializes an `SYRippleHighlighter` with the specified configuration.
    ///
    /// - Parameters:
    ///  - rippleColor: The color of the ripple effect.
    ///  - rippleDuration: The animation duration for the ripple.
    ///  - rippleRadius: The radius of the ripple. If `nil`, the ripple expands to the button’s bounds.
    ///  - trackLocation: If `true`, the ripple originates at the finger’s location.
    public init(rippleColor: UIColor, rippleDuration: CFTimeInterval, rippleRadius: CGFloat?, trackLocation: Bool) {
        self.rippleColor = rippleColor
        self.rippleDuration = rippleDuration
        self.rippleRadius = rippleRadius
        self.trackLocation = trackLocation
    }

    // MARK: SYButtonHighlighter

    public func highlight(_ button: SYButton, at location: CGPoint) {
        let rippleSize = rippleRadius ?? max(button.frame.width, button.frame.height)
        let rippleLayer = createRipple(with: rippleSize)
        rippleLayer.position = trackLocation
            ? location
            : CGPoint(x: button.frame.width / 2, y: button.frame.height / 2)

        // Scale from zero
        rippleLayer.transform = CATransform3DMakeScale(0.0, 0.0, 1.0)

        // Mask to ensure the ripple doesn’t escape the button’s rounded corners
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: button.bounds,
            cornerRadius: button.layer.cornerRadius
        ).cgPath
        maskLayer.frame = button.bounds

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
        guard let ripple = highlightedLayer?.sublayers?.first(where: { $0.name == rippleName }) else {
            return
        }
        highlightedLayer = nil

        let fadeAnimation = fadingAnimation()
        // Reverse the fade animation so it disappears quickly
        fadeAnimation.speed = -1
        fadeAnimation.delegate = self
        ripple.add(fadeAnimation, forKey: "rippleFadeOut")
    }
}

// MARK: - CAAnimationDelegate

extension SYRippleHighlighter: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let layer = anim.value(forKeyPath: "animationLayer") as? CALayer
        // Remove the highlight layer
        layer?.superlayer?.removeFromSuperlayer()
    }
}

// MARK: - Helpers

extension SYRippleHighlighter {
    /// Creates a circular layer of the given `radius` to serve as the ripple.
    private func createRipple(with radius: CGFloat) -> CAShapeLayer {
        let rippleLayer = CAShapeLayer()
        rippleLayer.backgroundColor = rippleColor.cgColor
        rippleLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        rippleLayer.cornerRadius = radius / 2
        rippleLayer.name = rippleName
        return rippleLayer
    }

    /// Creates the ripple’s group animation combining scale & fade.
    private func createRippleAnimation() -> CAAnimation {
        // Scale
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.fillMode = .forwards
        scaleAnimation.isRemovedOnCompletion = false

        // Fade
        let fadeAnimation = fadingAnimation()

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, fadeAnimation]
        animationGroup.duration = rippleDuration
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false

        return animationGroup
    }

    /// Creates a fade-in animation used for the ripple effect.
    private func fadingAnimation() -> CAAnimation {
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 1
        fadeAnimation.fillMode = .forwards
        fadeAnimation.isRemovedOnCompletion = false
        fadeAnimation.duration = rippleDuration
        return fadeAnimation
    }
}
