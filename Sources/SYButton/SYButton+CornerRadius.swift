//
//  SYButton+CornerRadius.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation

extension SYButton {
    /// `CornerRadius` defines the rounding behavior for the corners of the `SYButton`.
    public enum CornerRadius {
        /// Rounds the button corners to form a capsule shape based on the button's height.
        case rounded

        /// Applies a specific radius value to the button's corners.
        /// - Parameter value: The radius value to be applied to the corners.
        case radius(_ value: CGFloat)
    }
}
