//
//  SYButtonHighlighter.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A protocol that defines the requirements for a custom highlighter effect for `SYButton`.
///
/// The `SYButtonHighlighter` protocol allows for the creation of various highlight effects that can be applied to an `SYButton`.
/// Implementations of this protocol can define custom visual effects that occur when a button is pressed, moved within, or released.
///
/// Conforming types can implement effects such as scaling, rippling, or shadowing based on the user's interaction with the button.
public protocol SYButtonHighlighter {
    /// Starts the highlight effect on the button at the specified touch location.
    ///
    /// This method is called when the user first presses the button within its bounds. Implementations should apply a visual effect,
    /// such as scaling or color change, that provides feedback to the user.
    ///
    /// - Parameters:
    ///   - button: The `SYButton` on which the highlight effect is applied.
    ///   - location: The location of the tap within the button's bounds.
    func highlight(_ button: SYButton, at location: CGPoint)

    /// Stops the highlight effect on the button.
    ///
    /// This method is called when the user releases the button or moves their finger outside the button's bounds. Implementations
    /// should revert any changes made during the `highlight(_:at:)` method, returning the button to its normal state.
    ///
    /// - Parameter button: The `SYButton` on which the highlight effect is stopped.
    func stopHighlight(_ button: SYButton)

    /// Adjusts the highlight effect based on the user's finger movement
    ///
    /// This method is called whenever the user's finger moves within or outside the button's bounds while still pressing the button.
    /// Implementations can use this method to dynamically update the highlight effect, such as changing intensity or stopping the effect
    /// when the finger moves out of bounds.
    ///
    /// - Parameters:
    ///   - button: The `SYButton` on which the highlight effect is being applied.
    ///   - location: The new location of the user's finger within the button's bounds.
    func locationMoved(_ button: SYButton, to location: CGPoint)
}

extension SYButtonHighlighter {
    /// Default implementation for `locationMoved(_:)`.
    /// Does nothing unless overridden.
    public func locationMoved(_ button: SYButton, to location: CGPoint) {}
}
