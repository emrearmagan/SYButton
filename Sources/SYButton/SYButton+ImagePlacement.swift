//
//  SYButton+ImagePlacement.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation

extension SYButton {
    /// `ImagePlacement` defines the position of the icon relative to the button's title.
    public enum ImagePlacement: CaseIterable {
        /// The icon is placed to the leading side (left in left-to-right languages) of the title.
        case leading

        /// The icon is placed to the trailing side (right in left-to-right languages) of the title.
        case trailing

        /// The icon is placed above the title.
        case top

        /// The icon is placed below the title.
        case bottom
    }
}
