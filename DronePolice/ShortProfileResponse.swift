//
//  ShortProfileResponse.swift
//  followme
//
//  Created by Miguel Mexicano Herrera on 15/04/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation


class ShortProfileResponse {

    var contacto = Int()
    var existeRegistro = Int()
    var mySubscription = Int()
    var name = String()
    var pitcher = Int()
    var publicProfile = Int()
    var total = Int()
    var visitaPerfil = Int()
    

    
    init(contacto: Int, existeRegistro: Int, mySubscription: Int, name: String, pitcher: Int, publicProfile: Int, total: Int, visitaPerfil: Int ) {
        self.contacto = contacto
        self.existeRegistro = existeRegistro
        self.mySubscription = mySubscription
        self.name = name
        self.pitcher = pitcher
        self.publicProfile = publicProfile
        self.total = total
        self.visitaPerfil = visitaPerfil
    }
}
