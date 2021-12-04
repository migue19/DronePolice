//
//  ResponseGeneric.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 09/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

class ResponseGeneric {
    var estatus = Int()
    var error:String! = String()
    
    
    init(estatus: Int, error: String){
       self.estatus = estatus
       self.error = error
    }
    
}
