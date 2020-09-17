//
//  LoginEntity.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 17/08/20.
//  Copyright © 2020 Miguel Mexicano Herrera. All rights reserved.
//
import Foundation
struct SocialLoginResponse: Codable {
    var estatus: Int
    var token: String
}
struct SocialLoginRequest: Codable {
    let email: String
    let name: String
    let apePaterno: String
    let apeMaterno: String
    let numberCell: String
    let idSocial: String
    let social: String
    let imei: String
    let latitud: Double
    let longitud: Double
    let urlImage: URL?
}
struct QRServiceResponse: Codable {
    let estatus: Int
    let qr: String
}
