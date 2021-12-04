//
//  LoginRouter.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 06/09/20.
//  Copyright © 2020 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

final class LoginRouter {
    var view: LoginVC
    private var presenter: LoginPresenter
    private var interactor: LoginInteractor
    
    init() {
        self.view = LoginVC()
        self.presenter = LoginPresenter()
        self.interactor = LoginInteractor()
        view.presenter = self.presenter
        presenter.interactor = self.interactor
        presenter.view = self.view
        interactor.presenter = self.presenter
        presenter.router = self
    }
}
extension LoginRouter: LoginRouterProtocol {
    
}
