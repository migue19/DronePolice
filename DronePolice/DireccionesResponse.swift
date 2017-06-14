//
//  DireccionesResponse.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 14/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

class DireccionResponse {
    
    var estatus = Int()
    var error:String! = String()
    var direccion = Direccion()
    
    
    init(estatus: Int, error: String, direccion: Direccion){
        self.estatus = estatus
        self.error = error
        self.direccion = direccion
    }
    
}
