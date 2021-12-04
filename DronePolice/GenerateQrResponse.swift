//
//  GenerateQrResponse.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 04/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

class GenerarQrResponse {
    var estatus = Int()
    var qr = String()
    
    
    init(estatus: Int, qr: String)
    {
       self.estatus = estatus
       self.qr = qr
    }
}
