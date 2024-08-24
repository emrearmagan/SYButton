//
//  SYScaleHighlighter.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// `SYScaleHighlighter` is a highlighter class that applies visual transformations to an `SYButton` when it is highlighted.
///
/// This highlighter modifies the button's scale and alpha (opacity) to provide visual feedback during touch interactions.
public class SYScaleHighlighter: SYButtonHighlighter {
    // MARK: Properties

    /// Flag determines whether the highlighter should track the touch location within the button's bounds.
    public var tracklocation: Bool = false

    /// The scale factor applied to the button when it is highlighted.
    public var animationScale: CGFloat = 0.95

    /// The duration of the scaling animation.
    public var animationDuration: TimeInterval = 0.2

    /// The alpha value applied to the button when it is highlighted.
    public var highlightedAlpha: CGFloat = 0.8

    /// A flag to track whether the button is currently highlighted.
    private var highlighted = false

    // MARK: Init

    public convenience init() {
        self.init(tracklocation: false, animationScale: 0.95, animationDuration: 0.2, highlightedAlpha: 0.8)
    }

    /// Initializes a new instance of `SYScaleHighlighter` with the specified properties.
    /// - Parameters:
    ///   - tracklocation: A Boolean value that determines whether the highlighter should track the touch location within the button's bounds.
    ///   - animationScale: The scale factor applied to the button when it is highlighted.
    ///   - animationDuration: The duration of the scaling animation.
    ///   - highlightedAlpha: The alpha value applied to the button when it is highlighted.
    public init(tracklocation: Bool, animationScale: CGFloat, animationDuration: TimeInterval, highlightedAlpha: CGFloat) {
        self.tracklocation = tracklocation
        self.animationScale = animationScale
        self.animationDuration = animationDuration
        self.highlightedAlpha = highlightedAlpha
    }

    // MARK: Functions

    public func highlight(_ button: SYButton, at location: CGPoint) {
        guard !highlighted else { return }

        highlighted = true

        UIView.animate(withDuration: animationDuration, animations: {
            button.transform = CGAffineTransform(scaleX: self.animationScale, y: self.animationScale)
            button.alpha = self.highlightedAlpha
        })
    }

    public func stopHighlight(_ button: SYButton) {
        guard highlighted else { return }

        highlighted = false

        UIView.animate(withDuration: animationDuration, animations: {
            button.transform = CGAffineTransform.identity
            button.alpha = 1
        })
    }

    public func locationMoved(_ button: SYButton, to location: CGPoint) {
        guard tracklocation else { return }

        if button.bounds.contains(location) {
            // If the touch is within the button's bounds and highlighting is not active, start it
            if !highlighted {
                highlight(button, at: location)
            }
        } else {
            // If the touch moves outside the button's bounds and highlighting is active, stop it
            if highlighted {
                stopHighlight(button)
            }
        }
    }
}
