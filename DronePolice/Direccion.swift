//
//  Direccion.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 14/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

class Direccion{
    var identificador = String()
    var telefono = String()
    var referencia = String()
    var calle = String()
    var colonia = String()
    var municipio = String()
    var cp = String()
    var pais = String()
    var direccionid = Int()
    
    init(){
    }
    
    init(identificador: String,telefono: String,calle: String,referencia:String,colonia:String,municipio: String, cp:String, pais: String, direccionid: Int ){
        self.identificador = identificador
        self.telefono = telefono
        self.referencia = referencia
        self.calle = calle
        self.colonia = colonia
        self.municipio = municipio
        self.cp = cp
        self.pais = pais
        self.direccionid = direccionid
    
    }
    
}
