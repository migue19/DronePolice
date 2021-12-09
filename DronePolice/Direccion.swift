//
//  Direccion.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 14/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

struct Direccion: Codable {
    var identificador: String = ""
    var telefono: String?
    var referencia: String?
    var calle: String?
    var colonia: String?
    var municipio: String?
    var cp: String = ""
    var pais: String?
    var direccionid: Int = -1
    var noInt: String?
    var noExt: String?
    
    init() {}
    
    init(identificador: String,telefono: String,calle: String,referencia:String,colonia:String,municipio: String, cp:String, pais: String, direccionid: Int,noInt: String, noExt: String ){
        self.identificador = identificador
        self.telefono = telefono
        self.referencia = referencia
        self.calle = calle
        self.colonia = colonia
        self.municipio = municipio
        self.cp = cp
        self.pais = pais
        self.direccionid = direccionid
        self.noInt = noInt
        self.noExt = noExt
    }
}
