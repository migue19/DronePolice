//
//  BaseViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 06/09/20.
//  Copyright © 2020 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
class BaseViewController: UIViewController {
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
