//
//  SYButtonBackgroundView+CornerRadius.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation

extension SYButtonBackgroundView {
    /// Defines the corner-rounding behavior for `SYButtonBackgroundView`.
    public enum CornerRadius {
        /// Rounds the corners to create a capsule shape (based on the view's height).
        case rounded

        /// Uses a specific numeric corner radius.
        ///
        /// - Parameter value: The radius value to apply to each corner.
        case radius(_ value: CGFloat)
    }
}
