//
//  SYButtonBackgroundView.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A view that can display either a solid background color or a gradient with customizable corner radius.
///
/// - Note: Setting `backgroundColor` directly removes the gradient (if any).
public class SYButtonBackgroundView: UIView {
    // MARK: Properties

    private var gradienLayer: SYGradientLayer?

    /// The gradient colors for the background view.
    /// If non-`nil`, a gradient is applied using these colors.
    /// Setting this property reconfigures (or creates) the gradient layer.
    public var gradientColor: [UIColor]? {
        didSet { setupGradientBackground() }
    }

    /// The corner radius behavior for this view.
    /// It can be a specific radius or `.rounded` for a capsule shape.
    open var cornerRadius: CornerRadius = .radius(0) {
        didSet { setupBorder() }
    }

    /// The direction in which the gradient is drawn.
    /// Defaults to `.leftToRight`.
    public var gradientDirection: GradientDirection = .leftToRight

    /// The locations of each gradient stop within the gradient.
    /// If provided, these define the distribution of colors along the gradient.
    public var gradientLocations: [CGFloat]? {
        didSet { setupGradientBackground() }
    }

    /// Setting a background color removes any existing gradient layer.
    /// Overrides `UIView.backgroundColor`.
    override public var backgroundColor: UIColor? {
        didSet {
            gradienLayer?.removeFromSuperlayer()
            gradienLayer = nil
        }
    }

    // MARK: Lifecycle

    /// Ensures the view's border and gradient (if any) are laid out correctly.
    override public func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()

        if let layer = gradienLayer {
            layer.frame = bounds
            layer.cornerRadius = self.layer.cornerRadius
        }
    }

    // MARK: Methods

    /// Creates or updates the gradient layer with the current `gradientColor`,
    /// `gradientDirection`, and `gradientLocations`.
    private func setupGradientBackground() {
        if gradienLayer == nil {
            let gradient = SYGradientLayer()
            gradient.bounds = frame
            layer.insertSublayer(gradient, at: 0)
            gradienLayer = gradient
        }

        gradienLayer?.gradientColors = gradientColor
        gradienLayer?.gradientDirection = gradientDirection
        gradienLayer?.gradientLocations = gradientLocations
    }

    /// Applies the corner radius based on the `cornerRadius` property.
    /// If `.rounded`, the radius is half the view's height, creating a capsule shape.
    /// Otherwise, it uses the specified numeric value.
    private func setupBorder() {
        switch cornerRadius {
            case .rounded:
                layer.cornerRadius = 0.5 * frame.size.height
            case let .radius(value):
                layer.cornerRadius = value
        }
    }
}
