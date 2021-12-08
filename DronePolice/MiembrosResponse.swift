//
//  MiembrosResponse.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 14/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

struct MiembrosResponse: Codable {
    var error: String?
    var estatus: Int?
    var miembros: [MiembroDetail]
}

struct MiembroDetail: Codable {
    var id: Int
    var nombre: String
}
