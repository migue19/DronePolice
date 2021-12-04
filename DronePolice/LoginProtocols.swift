//
//  LoginProtocols.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 06/09/20.
//  Copyright © 2020 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

/// VIEW --> PRESENTER
protocol LoginPresenterProtocol {
    func sendLoginInformation(request: LoginRequest)
}
/// PRESENTER --> VIEW
protocol LoginViewProtocol: GeneralViewProtocol {
    
}
/// PRESENTER --> INTERACTOR
protocol LoginInteractorInputProtocol {
    func requestLogin(request: LoginRequest)
}
/// PRESENTER --> ROUTER
protocol LoginRouterProtocol {
    
}
/// INTERACTOR --> PRESENTER
protocol LoginInteractorOutputProtocol {
    func showError(message: String)
}
protocol GeneralViewProtocol {
    /// Función para mostrar el progress general.
    func showHUD()
    /// Función para ocultar el progress general.
    func hideHUD()
    /// Función para mostrar un mensaje en una alerta
    /// - Parameters:
    ///   - title: Título de la alerta
    ///   - message: Cadena con el mensaje a mostrarse en la alerta.
    func showAlert(title: String, message: String)
    func showToast(message: String)
}


