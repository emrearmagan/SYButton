//
//  SYGradientLayer.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

class SYGradientLayer: CAGradientLayer {
    /// The colors of the gradient layer.
    var gradientColors: [UIColor]? {
        didSet {
            self.colors = self.gradientColors?.map { $0.cgColor }
        }
    }

    /// The locations of the gradient stops.
    var gradientLocations: [CGFloat]? {
        didSet {
            self.locations = self.gradientLocations?.map { NSNumber(value: $0) }
        }
    }

    /// The direction of the gradient.
    var gradientDirection: SYButtonBackgroundView.GradientDirection = .leftToRight {
        didSet {
            self.startPoint = self.gradientDirection.startPoint
            self.endPoint = self.gradientDirection.endPoint
        }
    }
}
