//
//  DireccionesResponse.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 14/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

struct DireccionResponse: Codable {
    var estatus: Int?
    var error: String?
    var direccion: [Direccion]
    
    init(estatus: Int, error: String, direccion: [Direccion]){
        self.estatus = estatus
        self.error = error
        self.direccion = direccion
    }
}
