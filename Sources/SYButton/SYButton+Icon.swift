//
//  SYButton+Icon.swift
//  SYButton
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import UIKit

// MARK: - IconSource Struct

extension SYButton {
    /// `IconSource` defines the image and appearance properties for the button's icon.
    public struct IconSource {
        /// The image to be displayed as the button's icon.
        let image: UIImage?

        /// The size of the icon. Defaults to 25x25 points.
        let size: CGSize

        /// The color to tint the icon. If nil, the icon will use its original colors.
        let tintColor: UIColor?

        /// Initializes an empty `IconSource` with no image or tint color. Only internally used
        init() {
            self.init(image: nil, size: CGSize(width: 25, height: 25), tintColor: nil)
        }

        /// Initializes an `IconSource` with the specified image, size, and tint color.
        /// - Parameters:
        ///   - image: The image to be used as the button's icon.
        ///   - size: The size of the icon. Defaults to 25x25 points.
        ///   - tintColor: The color to tint the icon. Defaults to nil.
        public init(image: UIImage?, size: CGSize = CGSize(width: 25, height: 25), tintColor: UIColor? = nil) {
            self.image = image
            self.size = size
            self.tintColor = tintColor
        }
    }
}
