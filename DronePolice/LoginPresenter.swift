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
    
}
extension LoginPresenter: LoginInteractorOutputProtocol {
    
}

