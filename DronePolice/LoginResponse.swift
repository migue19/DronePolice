//
//  File.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 03/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

class LoginResponse {
    var token = String()
    var estatus = Int()
    
    init(token: String, estatus: Int) {
        self.token = token
        self.estatus = estatus
    }
}
