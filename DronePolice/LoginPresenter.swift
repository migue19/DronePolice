//
//  LoginPresenter.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 06/09/20.
//  Copyright © 2020 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

final class LoginPresenter {
    var view: LoginViewProtocol?
    var interactor: LoginInteractorInputProtocol?
    var router: LoginRouterProtocol?
    
}
extension LoginPresenter: LoginPresenterProtocol {
    func sendLoginInformation(request: LoginRequest) {
        interactor?.requestLogin(request: request)
    }
}
extension LoginPresenter: LoginInteractorOutputProtocol {
    func showError(message: String) {
        view?.showToast(message: message)
    }
}

