//
//  EstadosResponse.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 27/07/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

class EstadosResponse: Codable {
    var estatus: Int?
    var error: String?
    var estados: [Estado]
    
    init(estatus: Int, error: String, estados: [Estado]){
        self.estatus = estatus
        self.error = error
        self.estados = estados
    }
}
