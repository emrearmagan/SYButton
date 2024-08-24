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

    private var contentConstraints: [NSLayoutConstraint] = []

    private let outerStackView = UIStackView()
    private let contentStackView = UIStackView()
    private let labelStackView = UIStackView()
    private let _titleLabel = UILabel()
    private let _subtitle = UILabel()
    private let imageView = UIImageView()

    /// A view representing the main content area of the button. Including the title, subtitle and icon
    public let contentBackgroundView = UIView()

    /// A view representing the background of the button, supporting gradients and other visual effects.
    public let backgroundView = SYButtonBackgroundView()

    /// Caches the button's title and subtitle when loading is active.
    private var (cachedTitle, cachedSubtitle): (String?, String?)

    /// internal property indicating wherther the button is loading
    private var _isLoading: Bool = false

    /// internal property indicating the placement of the image
    private var _imagePlacement: ImagePlacement = .leading

    /// A view that represents the current icon or loading indicator, depending on the button's state.
    private var currentIcon: UIView {
        guard isLoading else { return imageView }
        return activityIndicator
    }

    // MARK: Public Properties

    override open var isSelected: Bool {
        didSet { updateHandler?(self) }
    }

    override open var isEnabled: Bool {
        didSet { updateHandler?(self) }
    }

    override open var isHighlighted: Bool {
        didSet { updateHandler?(self) }
    }

    override open var layoutMargins: UIEdgeInsets {
        get { backgroundView.layoutMargins }
        set { backgroundView.layoutMargins = newValue }
    }

    override open var backgroundColor: UIColor? {
        get { backgroundView.backgroundColor }
        set { backgroundView.backgroundColor = newValue }
    }

    /// Publicly accessible title label for customization.
    open var titleLabel: UILabel {
        return _titleLabel
    }

    /// Publicly accessible subtitle label for customization.
    open var subtitleLabel: UILabel {
        return _subtitle
    }

    /// The highlighter for this button.
    public var highlighter: SYButtonHighlighter?

    /// A handler that allows external configuration updates when the button's state changes.
    public var updateHandler: ((SYButton) -> Void)?

    /// The `IconSource` for the button, including image and tint color.
    open var icon: IconSource = .init() {
        didSet {
            updateViews()
        }
    }

    /// Flag indicating wherther the button is loading
    open var isLoading: Bool {
        get { _isLoading }
        set { setLoading(newValue) }
    }

    /// Closure that will be executed if the button has been preseed
    open var handler: ((_ sender: SYButton) -> Void)? = nil {
        didSet {
            setupGestureRecognizer()
        }
    }

    /// Optional haptic feedback configuration that will be triggered on button press.
    open var feedback: Feedback?

    /// Corner radius setting for the button.
    open var cornerRadius: CornerRadius = .radius(0) {
        didSet {
            setupBorder()
        }
    }

    /// Placement of the icon relative to the title.
    open var imagePlacement: ImagePlacement {
        get { _imagePlacement }
        set { setImagePlacement(newValue) }
    }

    /// Activity indicator used for loading.
    open var activityIndicator: SYLoadingIndicator = SYLoadingSpinner()

    // MARK: Init

    /// Convenience initializer for setting up the button with a title and handler.
    /// - Parameters:
    ///   - title: The text to display on the button.
    ///   - handler: Optional closure to handle button tap actions.
    public convenience init(title: String?, subtitle: String? = nil, handler: ((_ sender: SYButton) -> Void)? = nil) {
        self.init(frame: .zero)
        self.title = title
        subtitleLabel.text = subtitle
        self.handler = handler
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    public required init?(coder _: NSCoder) {
        super.init(frame: .zero)
        setupUI()
    }

    // MARK: Lifecycle

    override open func layoutSubviews() {
        super.layoutSubviews()

        setupBorder()
        updateViews()

        backgroundView.frame = bounds
    }

    // MARK: Functions

    /// Sets up the initial UI configuration for the button.
    private func setupUI() {
        contentInsets = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)
        contentBackgroundView.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)

        addSubview(backgroundView)
        backgroundView.addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(outerStackView)

        outerStackView.addArrangedSubview(contentStackView)
        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(labelStackView)

        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subtitleLabel)

        outerStackView.alignment = .fill
        outerStackView.axis = .vertical

        contentStackView.alignment = .center
        contentStackView.axis = .horizontal
        contentStackView.spacing = 4
        contentStackView.distribution = .fill

        labelStackView.axis = .vertical
        labelStackView.distribution = .fillProportionally
        labelStackView.alignment = .leading

        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 17)
        subtitleLabel.font = .systemFont(ofSize: 12)

        updateViews()
        setImagePlacement(imagePlacement)
        configureConstraints()

        // Disable user interaction for subviews
        backgroundView.isUserInteractionEnabled = false
        contentBackgroundView.isUserInteractionEnabled = false
        outerStackView.isUserInteractionEnabled = false
        contentStackView.isUserInteractionEnabled = false
        activityIndicator.isUserInteractionEnabled = false

        backgroundView.accessibilityIdentifier = "backgroundView"
        contentBackgroundView.accessibilityIdentifier = "contentView"
        titleLabel.accessibilityIdentifier = "titleLabel"
        subtitleLabel.accessibilityIdentifier = "subtitleLabel"
        imageView.accessibilityIdentifier = "iconView"
    }

    private func updateViews() {
        titleLabel.isHidden = title == nil
        subtitleLabel.isHidden = subtitleLabel.text == nil
        labelStackView.isHidden = titleLabel.isHidden && subtitleLabel.isHidden

        imageView.isHidden = icon.image == nil && !isLoading
        imageView.image = icon.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = icon.tintColor

        setupBorder()
    }

    /// Toggles the button's loading state, updates the title as needed.
    /// - Parameters:
    ///   - loading: A Boolean value indicating whether the button is in the loading state.
    ///   - title: An optional title to display while loading. If `nil`, the current title is used.
    ///   - userInteractionEnabled: A Boolean value indicating whether user interaction is enabled while loading.
    ///   - animationDuration: Value that determines the duration of the transition animation when entering or exiting the loading state. If `0`, the transition is not animated.
    open func setLoading(_ loading: Bool, with title: String? = nil, userInteractionEnabled: Bool = false, animationDuration: Double = 0.3) {
        guard loading != isLoading else { return }
        guard loading != isLoading else { return }

        isUserInteractionEnabled = userInteractionEnabled || !loading
        _isLoading = loading
        subtitleLabel.isHidden = true

        loading ? showLoading(with: title, animationDuration: animationDuration) : stopLoading(animationDuration: animationDuration)
    }

    /// Aligns the image or loading indicator based on the `imagePlacement` property and updates the layout accordingly.
    /// - Parameter imagePlacement: The `ImagePlacement` for the image or loading indicator
    open func setImagePlacement(_ imagePlacement: ImagePlacement) {
        guard self.imagePlacement != imagePlacement else { return }
        _imagePlacement = imagePlacement

        // Remove the current icon from the stack view
        currentIcon.removeFromSuperview()

        // Adjust the axis of the stack view and insert the icon at the correct position
        switch imagePlacement {
        case .leading, .trailing:
            contentStackView.axis = .horizontal
            contentStackView.insertArrangedSubview(currentIcon, at: imagePlacement == .leading ? 0 : 1)

        case .bottom, .top:
            contentStackView.axis = .vertical
            contentStackView.insertArrangedSubview(currentIcon, at: imagePlacement == .top ? 0 : 1)
        }
    }

    private func showLoading(with title: String?, animationDuration: Double) {
        cachedTitle = titleLabel.text // cache title before animation starts
        cachedSubtitle = subtitleLabel.text // cache subtitle before animation starts

        // get index of icon to replace it with loading indicator
        let imageIndex = contentStackView.arrangedSubviews.firstIndex(of: imageView) ?? 0
        activityIndicator.startAnimating()

        let animations = {
            self.imageView.isHidden = true
            self.imageView.removeFromSuperview()
            self.activityIndicator.removeFromSuperview()
            self.contentStackView.insertArrangedSubview(self.activityIndicator, at: imageIndex)

            self.titleLabel.text = title
            self.subtitleLabel.text = nil
            self.updateViews()
            self.updateHandler?(self)
        }

        let animated = animationDuration > 0
        if animated {
            UIView.transition(with: backgroundView,
                              duration: animationDuration,
                              options: .transitionCrossDissolve,
                              animations: animations)
        } else {
            animations()
        }
    }

    private func stopLoading(animationDuration: Double) {
        activityIndicator.stopAnimating()

        // get index of icon to replace it with loading indicator
        let indicatorIndex = contentStackView.arrangedSubviews.firstIndex(of: activityIndicator) ?? 0

        let animations = {
            self.activityIndicator.removeFromSuperview()
            self.contentStackView.insertArrangedSubview(self.imageView, at: indicatorIndex)
            self.titleLabel.text = self.cachedTitle
            self.subtitleLabel.text = self.cachedSubtitle

            self.updateViews()
            self.updateHandler?(self)
        }

        let animated = animationDuration > 0
        if animated {
            UIView.transition(with: backgroundView,
                              duration: animationDuration,
                              options: .transitionCrossDissolve,
                              animations: animations)
        } else {
            animations()
        }
    }

    /// Sets up gesture recognizers for button interactions.
    private func setupGestureRecognizer() {
        removeTarget(self, action: nil, for: .allEvents)

        if let handler = handler {
            addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        }
    }

    /// Handler for button press actions.
    @objc private func tapped(_ sender: SYButton) {
        switch feedback {
        case .selectionChanged:
            UISelectionFeedbackGenerator().selectionChanged()

        case let .impact(style):
            UIImpactFeedbackGenerator(style: style).impactOccurred()

        case let .notification(style):
            UINotificationFeedbackGenerator().notificationOccurred(style)

        case nil:
            break
        }

        sender.sendActions(for: .primaryActionTriggered)
        handler?(sender)
    }
}

// MARK: - Touch

extension SYButton {
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if let touch = touches.first {
            let location = touch.location(in: self)
            highlighter?.locationMoved(self, to: location)
        }
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self)
            highlighter?.highlight(self, at: location)
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        highlighter?.stopHighlight(self)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        highlighter?.stopHighlight(self)
    }
}

// MARK: - UI

extension SYButton {
    /// Removes and  configures the constraints for the button's layout.
    private func configureConstraints() {
        NSLayoutConstraint.deactivate(contentConstraints)
        guard backgroundView.isDescendant(of: self) else { return }

        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        contentConstraints = [
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentBackgroundView.leadingAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.leadingAnchor),
            contentBackgroundView.trailingAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.trailingAnchor),
            contentBackgroundView.topAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.topAnchor),
            contentBackgroundView.bottomAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.bottomAnchor),

            outerStackView.leadingAnchor.constraint(equalTo: contentBackgroundView.layoutMarginsGuide.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentBackgroundView.layoutMarginsGuide.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: contentBackgroundView.layoutMarginsGuide.topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: contentBackgroundView.layoutMarginsGuide.bottomAnchor),
        ]

        // Add icon size constraints with high priority
        let imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: icon.size.width)
        let imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: icon.size.height)
        imageWidthConstraint.priority = .defaultHigh
        imageHeightConstraint.priority = .defaultHigh

        contentConstraints.append(contentsOf: [imageWidthConstraint, imageHeightConstraint])

        // Activate the constraints
        NSLayoutConstraint.activate(contentConstraints)
    }

    private func setupBorder() {
        switch cornerRadius {
        case .rounded:
            backgroundView.layer.cornerRadius = 0.5 * backgroundView.frame.size.height

        case let .radius(value):
            backgroundView.layer.cornerRadius = value
        }
    }
}

// MARK: - Appearance

extension SYButton {
    /// The title text displayed on the button.
    public var title: String? {
        get { _titleLabel.text }
        set { _titleLabel.text = newValue }
    }

    /// The title color displayed on the button.
    public var textColor: UIColor {
        get { _titleLabel.textColor }
        set { _titleLabel.textColor = newValue }
    }

    /// The number of lines used to display the title text.
    public var numberOfLines: Int {
        get { _titleLabel.numberOfLines }
        set { _titleLabel.numberOfLines = newValue }
    }

    /// Alignment of content.
    public var alignment: UIStackView.Alignment {
        get { outerStackView.alignment }
        set { outerStackView.alignment = newValue }
    }

    /// Spacing between the image and title
    public var imagePadding: CGFloat {
        get { contentStackView.spacing }
        set { contentStackView.spacing = newValue }
    }

    /// Insets for the button's content.
    public var contentInsets: UIEdgeInsets {
        get { layoutMargins }
        set { layoutMargins = newValue }
    }
}
