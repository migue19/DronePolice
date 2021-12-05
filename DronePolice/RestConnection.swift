//
//  RestConnection.swift
//  followme
//
//  Created by Miguel Mexicano Herrera on 14/04/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//
import Foundation
import UIKit
import ConnectionLayer
class RestConnection{
    let settingsDAO = SettingsDAO()
    let connectionLayer = ConnectionLayer()
    
    
    func SendRequetService(url: String, body: [String: Any], secure:Bool, method: HTTPMethod, completionHandler: @escaping (Data?, String?) -> ())
    {
        if(secure){
            MethodHTTPSecure(url: url, body: body, method: method, completion: completionHandler)
        }
        else{
          MethodHTTP(url: url, body: body, method: method, completion: completionHandler )
        }
    }

    func MethodHTTPSecureImage(url: String, method: HTTPMethod, completion: @escaping (UIImage?, String?) -> () ){
        //Obtenerlos de la base de Datos Local
        print("Metodo Seguro")
        var user = "start@dronpolice.com"
        var password = "tok_1234567890"
        
        let context = AppDelegate.viewContext
        do{
            let settings = try context.fetch(Settings.fetchRequest())
            if settings.count > 0 {
                user = settingsDAO.getDateForDescription(description: "id")
                password = settingsDAO.getDateForDescription(description: "token")
            }
        }
        catch{
            print("Error al obtener los Datos de la DB-> AppDelegate ")
        }
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        print(base64Credentials)
        //let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        let headers: HTTPHeaders = HTTPHeaders([
            HTTPHeaders.authorization(username: user, password: password),
            HTTPHeaders.contentTypeJson,
            HTTPHeaders.acceptJson
        ])
        
        connectionLayer.connectionRequest(url: url, method: method, headers: headers, data: nil) { data, respString in
            guard let data = data else {
                completion(nil, respString)
                return
            }
            let image = UIImage(data: data)
            completion(image, nil)
        }
    }
    
    
    
    func MethodHTTPSecure(url: String,body: [String: Any], method: HTTPMethod, completion: @escaping (Data?, String?) -> () ){
        //Obtenerlos de la base de Datos Local
        print("Metodo Seguro")
        var user = "start@dronpolice.com"
        var password = "tok_1234567890"
    
        let context = AppDelegate.viewContext
        do{
            let settings = try context.fetch(Settings.fetchRequest())
            if settings.count > 0 {
                user = settingsDAO.getDateForDescription(description: "id")
                password = settingsDAO.getDateForDescription(description: "token")
            }
        }
        catch{
            print("Error al obtener los Datos de la DB-> AppDelegate ")
        }
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        print(base64Credentials)
//        let headers = [
//            "Authorization": "Basic \(base64Credentials)",
//            "Content-Type": "application/json",
//            "Accept": "application/json"
//        ]
        let headers: HTTPHeaders = HTTPHeaders([
            HTTPHeaders.authorization(username: user, password: password),
            HTTPHeaders.contentTypeJson,
            HTTPHeaders.acceptJson
        ])
        
        connectionLayer.connectionRequest(url: url, method: method, headers: headers, data: nil) { data, respString in
            guard let data = data else {
                completion(nil, respString)
                return
            }
            completion(data, nil)
        }
    }
    
    func MethodHTTP(url: String, body: [String: Any], method: HTTPMethod,completion: @escaping (Data?, String?) -> () ){
        print("Metodo Simple")
//        let headers = [
//            "Content-Type": "application/json",
//            "Accept": "application/json"
//        ]
        let headers: HTTPHeaders = HTTPHeaders([
            HTTPHeaders.contentTypeJson,
            HTTPHeaders.acceptJson
        ])
        connectionLayer.connectionRequest(url: url, method: method, headers: headers, data: nil) { data, respString in
            guard let data = data else {
                completion(nil, respString)
                return
            }
            completion(data, nil)
        }
    }
}
