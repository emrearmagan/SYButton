//
//  ExampleViewController.swift
//  SYButtonDemo
//
//  Created by Emre Armagan on 22.08.24.
//  Copyright © 2024 Emre Armagan. All rights reserved.
//

import SYButton
import UIKit

class ExampleViewController: UIViewController {
    @IBOutlet weak var contentStackview: UIStackView!

    @IBOutlet weak var simpleButton: SYButton!
    @IBOutlet weak var simpleButtonSubtitle: SYButton!

    @IBOutlet weak var highlightedButton: SYButton!
    @IBOutlet weak var rippleButton: SYButton!
    @IBOutlet weak var customHighlighterButton: SYButton!

    @IBOutlet weak var iconButton: SYButton!
    @IBOutlet weak var signUpButton: SYButton!
    @IBOutlet weak var githubButton: SYButton!

    @IBOutlet weak var rotatingButton: SYButton!
    @IBOutlet weak var alignedButton: SYButton!
    @IBOutlet weak var gradientButton: SYButton!

    // Array containing the buttons that should have no title while loading
    private lazy var noTitleButton = [
        iconButton, githubButton
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light

        setupNavigationBar()
        setupUI()
    }

    private func setupUI() {
        // MARK: Default

        simpleButton.title = "Simple Button"
        simpleButton.textColor = .white
        simpleButton.backgroundColor = .systemBlue
        simpleButton.activityIndicator.indicatorColor = .white
        simpleButton.cornerRadius = .rounded

        simpleButtonSubtitle.title = "Simple Button"
        simpleButtonSubtitle.subtitleLabel.text = "But i come with a subtitle"
        simpleButtonSubtitle.textColor = .white
        simpleButtonSubtitle.subtitleLabel.textColor = .white
        simpleButtonSubtitle.backgroundColor = .systemBlue
        simpleButtonSubtitle.activityIndicator.indicatorColor = .white
        simpleButtonSubtitle.cornerRadius = .radius(15)

        // MARK: Highlighter

        highlightedButton.title = "Tap me to highlight"
        highlightedButton.textColor = .white
        highlightedButton.backgroundColor = .systemBlue
        highlightedButton.icon = .init(image: .init(systemName: "message.fill"), tintColor: .white)
        highlightedButton.cornerRadius = .rounded
        highlightedButton.highlighter = SYScaleHighlighter()

        rippleButton.title = "Ripple Button"
        rippleButton.textColor = .white
        rippleButton.backgroundColor = .systemBlue
        rippleButton.cornerRadius = .rounded
        rippleButton.icon = .init(image: .init(systemName: "wand.and.stars"), tintColor: .white)
        rippleButton.highlighter = SYRippleHighlighter()

        customHighlighterButton.title = "Custom Button"
        customHighlighterButton.textColor = .white
        customHighlighterButton.backgroundColor = .systemBlue
        customHighlighterButton.cornerRadius = .rounded

        customHighlighterButton.contentBackgroundView.backgroundColor = .white.withAlphaComponent(0.3)
        customHighlighterButton.contentBackgroundView.layer.cornerRadius = 5
        customHighlighterButton.contentBackgroundView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        customHighlighterButton.icon = .init(image: .init(systemName: "camera.fill"), tintColor: .white)
        customHighlighterButton.highlighter = CustomHighlighter()

        // MARK: Loading indicators

        signUpButton.title = "Sign Up"
        signUpButton.textColor = .white
        signUpButton.backgroundColor = .black
        signUpButton.cornerRadius = .rounded
        signUpButton.icon = .init(image: .init(systemName: "person.fill"), tintColor: .white)
        signUpButton.activityIndicator = SYBallPulseIndicator()

        githubButton.title = "Github"
        githubButton.textColor = .white
        githubButton.backgroundColor = .black
        githubButton.cornerRadius = .rounded
        githubButton.icon = .init(image: .init(named: "github.icon"), tintColor: .white)
        githubButton.activityIndicator = SYLoadingSpinner()

        // MARK: Customization

        rotatingButton.title = "Tap me to rotate"
        rotatingButton.textColor = .white
        rotatingButton.backgroundColor = .black
        rotatingButton.cornerRadius = .rounded
        rotatingButton.icon = .init(image: .init(systemName: "heart.fill"), tintColor: .red)
        rotatingButton.handler = { sender in
            let allCases = SYButton.ImagePlacement.allCases
            let currentPlacement = allCases.firstIndex(where: { $0 == sender.imagePlacement }) ?? 0
            let nextPlacement = allCases[(currentPlacement + 1) % allCases.count]
            // animate the changes
            self.view.layoutIfNeeded()
            sender.setImagePlacement(nextPlacement)

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }

        iconButton.activityIndicator = UIActivityIndicatorView()
        iconButton.activityIndicator.indicatorColor = .white
        iconButton.backgroundColor = .black
        iconButton.textColor = .white
        iconButton.cornerRadius = .rounded
        iconButton.icon = .init(image: .init(systemName: "checkmark.circle.fill"), tintColor: .white)

        alignedButton.title = "Aligned Button"
        alignedButton.textColor = .white
        alignedButton.backgroundColor = .black
        alignedButton.cornerRadius = .rounded
        alignedButton.alignment = .leading
        alignedButton.icon = .init(image: .init(systemName: "arrow.right.circle.fill"), tintColor: .white)
        alignedButton.widthAnchor.constraint(equalTo: contentStackview.widthAnchor, multiplier: 0.8).isActive = true
        alignedButton.handler = { sender in
            let alignments: [UIStackView.Alignment] = [.leading, .trailing, .center]

            if let currentAlignment = alignments.firstIndex(of: sender.alignment) {
                sender.alignment = alignments[(currentAlignment + 1) % alignments.count]
            }

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }

        // MARK: Background

        gradientButton.title = "Gradient Button"
        gradientButton.textColor = .white
        gradientButton.icon = .init(image: .init(systemName: "lines.measurement.horizontal"), tintColor: .white)
        gradientButton.backgroundView.gradientColor = [
            UIColor(red: 0/255, green: 174/255, blue: 255/255, alpha: 1),
            UIColor(red: 0/255, green: 118/255, blue: 255/255, alpha: 1)
        ]
        gradientButton.backgroundView.layer.shadowColor = UIColor.black.cgColor
        gradientButton.backgroundView.layer.shadowRadius = 2
        gradientButton.backgroundView.layer.shadowOpacity = 0.2
        gradientButton.backgroundView.layer.shadowOffset = CGSize(width: 2, height: 2)
        gradientButton.highlighter = SYScaleHighlighter()
        gradientButton.cornerRadius = .rounded
    }

    private func setupNavigationBar() {
        title = "SYBanner"

        let rightButton = UIBarButtonItem(
            title: "Start loading",
            style: .done, target: self,
            action: #selector(startLoading(_:))
        )
        navigationItem.rightBarButtonItems = [rightButton]
    }
}

extension ExampleViewController {
    @objc private func startLoading(_ sender: UIBarButtonItem) {
        var isLoading = false
        for syButton in contentStackview.subviews.compactMap({ $0 as? SYButton }) {
            let title = noTitleButton.contains(syButton) ? nil : "Loading..."
            syButton.setLoading(!syButton.isLoading, with: title)
            isLoading = syButton.isLoading
        }

        navigationItem.rightBarButtonItem?.title = isLoading ? "Stop" : "Start Loading"
    }
}

// MARK: Highlighter

private class CustomHighlighter: NSObject, SYButtonHighlighter, CAAnimationDelegate {
    // MARK: Functions

    private var highlighted = false
    private var overlayView: UIView?

    public func highlight(_ button: SYButton, at location: CGPoint) {
        guard !highlighted else { return }

        highlighted = true
        let convertedFrame = button.contentBackgroundView.convert(button.contentBackgroundView.bounds, to: button)

        let overlayView = UIView(frame: convertedFrame)
        overlayView.backgroundColor = button.contentBackgroundView.backgroundColor
        overlayView.layer.cornerRadius = button.contentBackgroundView.layer.cornerRadius
        overlayView.isUserInteractionEnabled = false

        self.overlayView = overlayView
        button.insertSubview(overlayView, belowSubview: button.contentBackgroundView)
        button.contentBackgroundView.backgroundColor = .clear

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            guard let overlayView = self.overlayView else { return }
            let scaleX = button.bounds.width / overlayView.bounds.width
            let scaleY = button.bounds.height / overlayView.bounds.height
            overlayView.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        }, completion: nil)
    }

    func stopHighlight(_ button: SYButton) {
        guard highlighted else { return }

        highlighted = false
        guard let overlayView = overlayView else { return }

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            overlayView.transform = .identity
        }, completion: { _ in
            guard !self.highlighted else { return }
            button.contentBackgroundView.backgroundColor = overlayView.backgroundColor

            // Remove the overlay view after the animation is completed
            overlayView.removeFromSuperview()
            self.overlayView = nil
        })
    }
}
