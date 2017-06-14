//
//  RestConnection.swift
//  followme
//
//  Created by Miguel Mexicano Herrera on 14/04/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



enum Path:String {
    case SERVICE_TEST = "http://189.206.53.12/paychat-core/secured/chatService/profile/getShortProfile"
    case ACCESS_USER = "http://dronepolice.com.mx/drone/api/v1/usuarios-accesos"
    case REGISTRO_SOCIAL = "http://rest.dronepolice.com.mx/dronpolice-core/secured/dronpoliceService/registro"
    case ESTADOS = "http://rest.dronepolice.com.mx/dronpolice-core/secured/dronpoliceService/estados"
    case GENERARCODIGO = "http://rest.dronepolice.com.mx/dronpolice-core/secured/dronpoliceService/generarCodigo"
    case BOTONPANICO = "http://rest.dronepolice.com.mx/dronpolice-core/secured/dronpoliceService/botonPanico"
    case AGREGARDIRECCION = "http://rest.dronepolice.com.mx/dronpolice-core/secured/dronpoliceService/agregarDireccion"
    case REGISTERDEVICE = "http://rest.dronepolice.com.mx/dronpolice-core/secured/dronpoliceService/registroDispositivo"
    case ALERTASOSPECHOSO = "http://rest.dronepolice.com.mx/dronpolice-core/secured/dronpoliceService/botonSospechoso"
    case OBTENERDIRECCIONES = "http://rest.dronepolice.com.mx/dronpolice-core/secured/dronpoliceService/obtenerDireccion"
    
}

class RestConnection{
    let settingsDAO = SettingsDAO()
    
    
    func SendRequetService(url: String, body: Parameters, secure:Bool, method: HTTPMethod, completionHandler: @escaping (JSON?, Error?) -> ())
    {
        if(secure){
            MethodHTTPSecure(url: url, body: body, method: method, completion: completionHandler)
        }
        else{
          MethodHTTP(url: url, body: body, method: method, completion: completionHandler )
        }
    }
    
    
    
    func MethodHTTPSecure(url: String,body: Parameters, method: HTTPMethod, completion: @escaping (JSON?, Error?) -> () ){
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
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        

        
        Alamofire.request(url,method: method,parameters: body,encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            print(response.request?.allHTTPHeaderFields as Any)  // original URL request
            //print("Response HTTP URL:", response.response!) // HTTP URL response
            print(response.data!)     // server data
            print("Response Serialization: ", response.result)   // result of response serialization
         
            switch response.result{
            case .success(let value):
                print(value)
                
                completion(JSON(value), nil)
                
            case .failure(let error):
                completion(nil, error)
            }
            
            
        }
        
    }
    
    
    func MethodHTTP(url: String, body: Parameters, method: HTTPMethod, completion: @escaping (JSON?, Error?) -> () ){
         print("Metodo Simple")
        Alamofire.request(url, method: method,parameters: body, encoding: JSONEncoding.default).responseJSON { response in
            print(response.request as Any)  // original URL request
            //print("Response HTTP URL:", response.response! ) // HTTP URL response
            print(response.data!)     // server data
            print("Response Serialization: ", response.result)   // result of response serialization
          
            switch response.result{
            case .success(let value):
                print(value)
                    completion(JSON(value), nil)
                
            case .failure(let error):
                    completion(nil, error)
            }
            
        }

    }
    
    
  




}
