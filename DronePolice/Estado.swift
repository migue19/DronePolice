//
//  Estado.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 27/07/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

class Estado: Codable {
    var estadoid: Int?
    var nombre: String?
    init(){}
    init(estadoid: Int, nombre: String) {
        self.estadoid = estadoid
        self.nombre = nombre
    }
}
