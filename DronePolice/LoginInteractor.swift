//
//  LoginInteractor.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 06/09/20.
//  Copyright © 2020 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

final class LoginInteractor {
    var presenter: LoginInteractorOutputProtocol?
    let restService = RestService()
}
extension LoginInteractor: LoginInteractorInputProtocol {
    func requestLogin(request: LoginRequest) {
        restService.AccessUser(request: request) { (response, errorString, error) in
//            guard let response = response else {
//                if let messageError = errorString 
//                return
//            }
//            if let = error errorString != nil {
//                presenter?.showError(message: errorString)
//            }
        }
    }
}
