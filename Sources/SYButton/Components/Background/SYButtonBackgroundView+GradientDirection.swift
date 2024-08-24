//
//  SYButtonBackgroundView+GradientDirection.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation

extension SYButtonBackgroundView {
    public enum GradientDirection {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
        case topLeftToBottomRight
        case bottomRightToTopLeft
        case topRightToBottomLeft
        case bottomLeftToTopRight
    }
}

extension SYButtonBackgroundView.GradientDirection {
    var startPoint: CGPoint {
        switch self {
        case .leftToRight: return CGPoint(x: 0, y: 0.5)
        case .rightToLeft: return CGPoint(x: 1, y: 0.5)
        case .topToBottom: return CGPoint(x: 0.5, y: 0)
        case .bottomToTop: return CGPoint(x: 0.5, y: 1)
        case .topLeftToBottomRight: return CGPoint(x: 0, y: 0)
        case .bottomRightToTopLeft: return CGPoint(x: 1, y: 1)
        case .topRightToBottomLeft: return CGPoint(x: 1, y: 0)
        case .bottomLeftToTopRight: return CGPoint(x: 0, y: 1)
        }
    }

    var endPoint: CGPoint {
        switch self {
        case .leftToRight: return CGPoint(x: 1, y: 0.5)
        case .rightToLeft: return CGPoint(x: 0, y: 0.5)
        case .topToBottom: return CGPoint(x: 0.5, y: 1)
        case .bottomToTop: return CGPoint(x: 0.5, y: 0)
        case .topLeftToBottomRight: return CGPoint(x: 1, y: 1)
        case .bottomRightToTopLeft: return CGPoint(x: 0, y: 0)
        case .topRightToBottomLeft: return CGPoint(x: 0, y: 1)
        case .bottomLeftToTopRight: return CGPoint(x: 1, y: 0)
        }
    }
}
