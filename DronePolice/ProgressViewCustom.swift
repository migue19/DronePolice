//
//  ProgressViewCustom.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 04/12/21.
//  Copyright © 2021 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation
import UIKit
import Lottie
class ProgressViewCustom {
    var loader: AnimationView
    var viewWithBlurredBackground: UIVisualEffectView
    let widthProgress: CGFloat = 200.0
    let animationSpeed: CGFloat = 1.0
    var contentView: UIView
    init(inView: UIView) {
        self.contentView = inView
        loader = AnimationView(name: "loader2")
        loader.contentMode = .scaleAspectFit
        loader.loopMode = .loop
        loader.animationSpeed = animationSpeed
        let effect = UIBlurEffect(style: .light)
        viewWithBlurredBackground = UIVisualEffectView(effect: effect)
        viewWithBlurredBackground.frame = inView.frame
        viewWithBlurredBackground.contentView.addSubview(loader)
        loaderConstraints()
    }
    private func loaderConstraints() {
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: viewWithBlurredBackground.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: viewWithBlurredBackground.centerYAnchor),
            loader.widthAnchor.constraint(equalToConstant: widthProgress),
            loader.heightAnchor.constraint(equalToConstant: widthProgress)
        ])
    }
    private func contentConstraints() {
        viewWithBlurredBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewWithBlurredBackground.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            viewWithBlurredBackground.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            viewWithBlurredBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewWithBlurredBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    func startProgressView() {
        contentView.addSubview(viewWithBlurredBackground)
        contentConstraints()
        loader.play()
    }
    func stopProgressView() {
        loader.stop()
        stopAnimated()
    }
    private func stopAnimated() {
        viewWithBlurredBackground.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: { [weak self] in
            self?.viewWithBlurredBackground.alpha = 0.0
        }, completion: { [weak self] _ in
            self?.dismissViews()
        })
    }
    private func dismissViews() {
        loader.removeFromSuperview()
        viewWithBlurredBackground.removeFromSuperview()
    }
}
