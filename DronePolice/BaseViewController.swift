//
//  BaseViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 06/09/20.
//  Copyright © 2020 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import SwiftMessages
class BaseViewController: UIViewController {
    var tagsShowKeyboard = [100, 200 ,300]
    var progress: ProgressViewCustom?
    override func viewDidLoad() {
        progress = ProgressViewCustom(inView: self.view)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func showHUD() {
        progress?.startProgressView()
    }
    func hideHUD() {
        progress?.stopProgressView()
    }
    /// Función para mostrar un toast
    func showMessage(message: String, type: Theme) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(type)
        view.button?.isHidden = true
        view.iconImageView?.isHidden = true
        view.titleLabel?.isHidden = true
        view.iconLabel?.isHidden = true
        view.configureDropShadow()
        view.configureContent(body: message)
        view.layoutMarginAdditions = UIEdgeInsets(top: 5, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        let config = getConfigMessage()
        SwiftMessages.show(config: config, view: view)
    }
    /// Función para obteber la configuracion para el mensaje de error.
    func getConfigMessage() -> SwiftMessages.Config {
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .statusBar)
        config.prefersStatusBarHidden = true
        config.duration = .seconds(seconds: 3.0)
        config.dimMode = .gray(interactive: true)
        config.interactiveHide = false
        config.preferredStatusBarStyle = .lightContent
        return config
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if printKeyboardWillShow() {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if printKeyboardWillShow() {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAccion = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAccion)
        present(alert, animated: true, completion: nil)
    }
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
extension BaseViewController {
    func printKeyboardWillShow() -> Bool {
        if let firstResponder = self.findFirstResponder(inView: self.view) {
            let tag = firstResponder.tag
            return tagsShowKeyboard.contains(tag)
        }
        return false
    }
    func findFirstResponder(inView view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder {
                return subView
            }

            if let recursiveSubView = self.findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }

        return nil
    }
}
