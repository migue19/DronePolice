//
//  MiembrosResponse.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 14/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

class MiembrosResponse {
    
    var estatus = Int()
    var error:String! = String()
    var miembros = [Miembro]()
    
    
    init(estatus: Int, error: String, miembros: [Miembro]){
        self.estatus = estatus
        self.error = error
        self.miembros = miembros
    }
    
}
