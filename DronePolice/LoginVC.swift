//
//  LoginVC.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 06/09/20.
//  Copyright © 2020 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController {
    var presenter: LoginPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension LoginVC: LoginViewProtocol {
    
}
