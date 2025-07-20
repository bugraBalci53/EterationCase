//
//  LoadingManager.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 21.07.2025.
//

import UIKit

final class LoadingManager {
    static let shared = LoadingManager()

    private var loadingWindow: UIWindow?

    private init() {}

    func show() {
        guard loadingWindow == nil else { return }

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        window.frame = UIScreen.main.bounds
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear

        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])

        window.rootViewController = vc
        window.makeKeyAndVisible()
        loadingWindow = window
    }

    func hide() {
        DispatchQueue.main.async {
            self.loadingWindow?.isHidden = true
            self.loadingWindow = nil
        }
    }
}
