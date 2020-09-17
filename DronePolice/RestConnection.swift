//
//  RestConnection.swift
//  followme
//
//  Created by Miguel Mexicano Herrera on 14/04/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//
import Foundation
import UIKit
public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    /// `TRACE` method.
    public static let trace = HTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

class RestConnection{
    let settingsDAO = SettingsDAO()
    
    
    func SendRequetService(url: String, body: [String: Any], secure:Bool, method: HTTPMethod, completionHandler: @escaping (Data?, String?) -> ())
    {
        if(secure){
            MethodHTTPSecure(url: url, body: body, method: method, completion: completionHandler)
        }
        else{
          MethodHTTP(url: url, body: body, method: method, completion: completionHandler )
        }
    }
    
    func getSessionConfiguration() -> URLSessionConfiguration {
        let time = 180 /// 3 minutos
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(time)
        configuration.timeoutIntervalForResource = TimeInterval(time)
        return configuration
    }
    
    

    func conneccionRequest(url: String, method: String, headers: [String: String], parameters: [String: Any]?, closure: @escaping (Data?,String?) -> Void) {
        let configuration = getSessionConfiguration()
        let session = URLSession(configuration: configuration)
        guard let url = URL(string: url) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        if let param = parameters {
            do{
                let httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
                request.httpBody = httpBody
            }catch {
                print(error)
            }
        }
        session.dataTask(with: request) { (data, response, error) in
            if(error != nil){
                closure(nil,"Error de conexion")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                return
            }
            self.printResultHttpConnection(data: data)
            switch(httpResponse.statusCode){
            case 200:
                closure(data,nil)
                print("Servicio exitoso")
                break
            case 404:
                closure(nil,"Servicio no Encontrado")
                print("Servicio no Encontrado")
                break
            case 500:
                closure(nil,"Error en el Servicio")
                break
            default:
                closure(nil,"el servicio regreso un codigo \(httpResponse.statusCode)")
                print("el servicio regreso un codigo \(httpResponse.statusCode)")
                break
            }
        }.resume()
    }
    
    
    func printResultHttpConnection(data: Data?){
        guard let data = data else {
            return
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(jsonObject)
        } catch {
            print(error)
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
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        conneccionRequest(url: url, method: method.rawValue, headers: headers, parameters: nil) { (data, respString) in
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
        let headers = [
            "Authorization": "Basic \(base64Credentials)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        conneccionRequest(url: url, method: method.rawValue, headers: headers, parameters: body) { (data, respString) in
            guard let data = data else {
                completion(nil, respString)
                return
            }
            completion(data, nil)
        }
    }
    
    func MethodHTTP(url: String, body: [String: Any], method: HTTPMethod,completion: @escaping (Data?, String?) -> () ){
        print("Metodo Simple")
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        conneccionRequest(url: url, method: method.rawValue, headers: headers, parameters: body) { (data, respString) in
            guard let data = data else {
                completion(nil, respString)
                return
            }
            completion(data, nil)
        }
    }
}
