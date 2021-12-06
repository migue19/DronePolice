//
//  Constants.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 14/08/20.
//  Copyright © 2020 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

struct Path {
    /// Url principal de microservicios.
    static private var base: String {
        return "http://pay.inovaweb.com.mx/dronpolice-core/secured/dronpoliceService"
    }
    /// Url para modulo de pago de servicios.
    static var SERVICE_TEST: String {
        return "http://189.206.53.12/paychat-core/secured/chatService/profile/getShortProfile"
    }
    /// Url para modulo de pago de servicios.
    static var ACCESS_USER: String {
        return Path.base + "/acceso"
    }
    /// Url para modulo de preferencias para salud financiera.
    static var REGISTRO_SOCIAL: String {
        return Path.base + "/registro"
    }
    /// Url para migración N2 - N3.
    static var ESTADOS: String {
        return Path.base + "/estados"
    }
    /// Url para migración N2 - N3.
    static var GENERARCODIGO: String {
        return Path.base + "/generarCodigo"
    }
    /// Url para migración N2 - N3.
    static var BOTONPANICO: String {
        return Path.base + "/botonPanico"
    }
    /// Url para migración N2 - N3.
    static var AGREGARDIRECCION: String {
        return Path.base + "/agregarDireccion"
    }
    /// Url para migración N2 - N3.
    static var ACTUALIZARDIRECCION: String {
        return Path.base + "/actualizarDireccion"
    }
    /// Url para migración N2 - N3.
    static var REGISTERDEVICE: String {
        return Path.base + "/registroDispositivo"
    }
    /// Url para migración N2 - N3.
    static var ALERTASOSPECHOSO: String {
        return Path.base + "/botonSospechoso"
    }
    /// Url para migración N2 - N3.
    static var OBTENERDIRECCIONES: String {
        return Path.base + "/obtenerDireccion"
    }
    /// Url para migración N2 - N3.
    static var MIEMBROSFAMILIARES: String {
        return Path.base + "/miembrosFamiliares"
    }
    /// Url para migración N2 - N3.
    static var MIEMBROSVECINOS: String {
        return Path.base + "/miembrosVecinos"
    }
    /// Url para migración N2 - N3.
    static var AGREGARMIEMBRO: String {
        return Path.base + "/agregarMiembro"
    }
    /// Url para migración N2 - N3.
    static var ELIMINARMIEMBRO: String {
        return Path.base + "/eliminarMiembro"
    }
}
