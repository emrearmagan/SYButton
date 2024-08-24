//
//  SYButton+Feedback.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

extension SYButton {
    /// `Feedback` defines the haptic feedback options that can be triggered when the button is tapped.
    public enum Feedback {
        /// Triggers a selection changed feedback.
        case selectionChanged

        /// Triggers an impact feedback with the specified style.
        /// - Parameter style: The style of impact feedback, such as `.light`, `.medium`, or `.heavy`.
        case impact(style: UIImpactFeedbackGenerator.FeedbackStyle)

        /// Triggers a notification feedback with the specified type.
        /// - Parameter style: The type of notification feedback, such as `.success`, `.warning`, or `.error`.
        case notification(style: UINotificationFeedbackGenerator.FeedbackType)
    }
}
