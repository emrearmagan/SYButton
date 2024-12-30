//
//  SYGradientLayer.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A custom `CAGradientLayer` subclass that stores additional properties about
/// gradient colors, locations, and direction.
class SYGradientLayer: CAGradientLayer {
    /// The colors used by the gradient.
    /// Converted internally to `cgColor` and set on `CAGradientLayer.colors`.
    var gradientColors: [UIColor]? {
        didSet {
            colors = gradientColors?.map { $0.cgColor }
        }
    }

    /// The locations of each color stop, mapped to `CAGradientLayer.locations`.
    var gradientLocations: [CGFloat]? {
        didSet {
            locations = gradientLocations?.map { NSNumber(value: Float($0)) }
        }
    }

    /// The direction in which the gradient should be drawn.
    /// Sets `startPoint` and `endPoint` accordingly.
    var gradientDirection: SYButtonBackgroundView.GradientDirection = .leftToRight {
        didSet {
            startPoint = gradientDirection.startPoint
            endPoint = gradientDirection.endPoint
        }
    }
}
