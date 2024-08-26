//
//  SYButtonBackgroundView.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

public class SYButtonBackgroundView: UIView {
    private var gradienLayer: SYGradientLayer?

    /// The gradient colors for the background view. If set, a gradient is applied based on these colors.
    public var gradientColor: [UIColor]? {
        didSet {
            self.setupGradientBackground()
        }
    }

    /// Corner radius setting of the view.
    open var cornerRadius: SYButtonBackgroundView.CornerRadius = .radius(0) {
        didSet {
            self.setupBorder()
        }
    }

    /// The direction of the gradient. The default is `.leftToRight`.
    public var gradientDirection: GradientDirection = .leftToRight

    /// The locations of the gradient stops. If set, defines the location of each gradient stop.
    public var gradientLocations: [CGFloat]? {
        didSet {
            self.setupGradientBackground()
        }
    }

    /// Sets the background color of the view. Removes any existing gradient layer when set.
    override public var backgroundColor: UIColor? {
        didSet {
            self.gradienLayer?.removeFromSuperlayer()
            self.gradienLayer = nil
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.setupBorder()
        if self.gradienLayer != nil {
            self.gradienLayer?.frame = self.bounds
            self.gradienLayer?.cornerRadius = self.layer.cornerRadius
        }
    }

    private func setupGradientBackground() {
        if self.gradienLayer == nil {
            self.gradienLayer = SYGradientLayer()
            self.gradienLayer!.bounds = self.frame

            layer.insertSublayer(self.gradienLayer!, at: 0)
        }

        self.gradienLayer!.gradientColors = self.gradientColor
        self.gradienLayer!.gradientDirection = self.gradientDirection
        self.gradienLayer!.gradientLocations = self.gradientLocations
    }

    private func setupBorder() {
        switch self.cornerRadius {
        case .rounded:
            layer.cornerRadius = 0.5 * frame.size.height

        case let .radius(value):
            layer.cornerRadius = value
        }
    }
}
