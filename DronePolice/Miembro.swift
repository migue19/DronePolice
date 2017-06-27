//
//  Miembro.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 14/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

class Miembro{
    var id = Int()
    var nombre = String()
   
    
    init(){
    }
    
    init(id: Int,nombre: String ){
        self.id = id
        self.nombre = nombre 
    }
    
}
