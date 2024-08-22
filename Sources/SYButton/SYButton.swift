//
//  SYButton.swift
//
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

open class SYButton: UIControl {
    // MARK: Properties

    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()

    open var cornerRadius: CornerRadius = .radius(0) {
        didSet {
            setupBorder()
        }
    }

    // MARK: Init

    public convenience init() {
        self.init(frame: .zero)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    override open func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()
    }

    private func setupUI() {
        contentStackView.axis = .horizontal
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)

        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }

    private func setupBorder() {
        switch cornerRadius {
        case .rounded:
            layer.cornerRadius = 0.5 * frame.size.height

        case let .radius(value):
            layer.cornerRadius = value
        }
    }
}

// MARK: - Appearance

extension SYButton {
    public var text: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    public var numberOfLines: Int {
        get { titleLabel.numberOfLines }
        set { titleLabel.numberOfLines = newValue }
    }

    public var textAlignment: NSTextAlignment {
        get { titleLabel.textAlignment }
        set { titleLabel.textAlignment = newValue }
    }

    public var axis: NSLayoutConstraint.Axis {
        get { contentStackView.axis }
        set { contentStackView.axis = newValue }
    }
}
