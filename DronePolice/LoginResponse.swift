//
//  File.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 03/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation
struct RegisterResponse: Codable {
    var estatus: Int
    var error: String?
    var token: String?
}

struct LoginResponse: Codable {
    var estatus: Int
    var error: String?
    var token: String?
    var nombre: String?
}
