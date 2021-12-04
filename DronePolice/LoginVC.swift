//
//  LoginVC.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 06/09/20.
//  Copyright © 2020 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import FacebookLogin
/// Clase para controlar el Acceso de Usuarios
class LoginVC: BaseViewController {
    @IBOutlet weak var userTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var facebookButton: CustomButton!
    @IBOutlet weak var googleButton: CustomButton!
    var presenter: LoginPresenterProtocol?
    let latitude: Double = 0.0
    let longitude: Double = 0.0
    let uuid = UUID().uuidString
    override func viewDidLoad() {
        super.viewDidLoad()
    }    
    @IBAction func pressFacebookButton(_ sender: Any) {
    }
    @IBAction func pressGoogleButton(_ sender: Any) {
    }
    @IBAction func pressLoginButton(_ sender: Any) {
        guard let user = userTextField.text, user != "", let password = passwordTextField.text, password != "" else {
            showAlert(title: "Campos obligatorios", message: "El usuario y contraseña no pueden ser vacios")
            return
        }
        let request = LoginRequest(latitude: latitude, longitude: longitude, imei: uuid, user: user, password: password)
        presenter?.sendLoginInformation(request: request)
    }
    @IBAction func pressRegisterButton(_ sender: Any) {
    }
}
extension LoginVC: LoginViewProtocol {
    func showHUD() {
    }
    
    func hideHUD() {
    }
}
