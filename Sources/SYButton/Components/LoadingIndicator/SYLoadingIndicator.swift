//
//  SYLoadingIndicator.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// `SYLoadingIndicator` is a protocol that defines the requirements for a custom loading indicator view for the SYButton.
///
/// The protocol also includes a property to check if the indicator is currently animating and to customize its color.
public protocol SYLoadingIndicator: UIView {
    /// A Boolean value indicating whether the loading indicator is currently animating.
    var isAnimating: Bool { get }

    /// The color of the loading indicator. This property allows customization of the indicator's appearance.
    var indicatorColor: UIColor { get set }

    /// Starts the loading animation.
    func startAnimating()

    /// Stops the loading animation.
    func stopAnimating()
}

public extension SYLoadingIndicator {
    static var `default`: SYLoadingIndicator { UIActivityIndicatorView() }
    static var spinner: SYLoadingIndicator { SYLoadingSpinner() }
    static var ballPulse: SYLoadingIndicator { SYBallPulseIndicator() }
}

/// Extend `UIActivityIndicatorView` to conform to `SYLoadingIndicator`.
extension UIActivityIndicatorView: SYLoadingIndicator {
    /// The color of the `UIActivityIndicatorView`. This conforms to the `SYLoadingIndicator` protocol's `indicatorColor` property.
    public var indicatorColor: UIColor {
        get { color }
        set { color = newValue }
    }
}
