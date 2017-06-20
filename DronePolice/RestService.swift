//
//  RestService.swift
//  followme
//
//  Created by Miguel Mexicano Herrera on 14/04/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation
import Alamofire
import Firebase



class RestService{
    let restConnction = RestConnection()
    let settingsDAO = SettingsDAO()
    
    func ObtenerDirecciones(latitud: Double,longitud: Double ,completionHandler: @escaping (DireccionResponse?,String?,Error?) -> ()){
    
        //Utils().showLoading(context: context)
        let imei = settingsDAO.getDateForDescription(description: "imei")!
        let fecha = Utils().FechaActual()
      
        let parameters: Parameters = [
            "imei": imei,
            "fecha": fecha,
            "latitud": latitud,
            "longitud": longitud,
        ]
        
        restConnction.SendRequetService(url: Path.OBTENERDIRECCIONES.rawValue, body: parameters, secure: true, method: .post) { (response, error) in
            if error != nil{
                print("Ocurrio un error al validar el usuario: ", error!)
                completionHandler(nil,nil,error)
                return
            }
            
            let estatus = response!["estatus"].int!
            var resperror = ""
            if(estatus == 0){
                resperror =  response!["error"].string!
                completionHandler(nil,resperror,nil)
                return
            }
            
            
            let direcciones = response!["direccion"].arrayValue
    

        var ArrayDirecciones = [Direccion]()
            
            
            for direccion in direcciones{
                //let auxestado = estado.dictionaryValue
                let calle = direccion["calle"].string!
                let colonia = direccion["colonia"].string!
                let cp = direccion["cp"].string!
                let direccionid = direccion["direccionid"].int!
                let identificador = direccion["identificador"].string!
                let municipio = direccion["municipio"].string!
                let pais = direccion["pais"].string!
                let referencia = direccion["referencia"].string!
                let telefono = direccion["telefono"].string!
                
                let auxDireccion = Direccion.init(identificador: identificador, telefono: telefono, calle: calle, referencia: referencia, colonia: colonia, municipio: municipio, cp: cp, pais: pais, direccionid: direccionid)
                
                ArrayDirecciones.append(auxDireccion)
                //print(estadoid)
                
            }
            
            let dirResponse = DireccionResponse.init(estatus: estatus, error: resperror, direccion: ArrayDirecciones)
            
            
            
            completionHandler(dirResponse,nil, nil)
        }
    }
    
    
    
    
    
    func EnviarSospechoso(comentarios: String, foto: String,latitud: Double, longitud: Double ,completionHandler: @escaping (ResponseGeneric?,String? ,Error?) -> ()){
        
        //Utils().showLoading(context: context)
        let imei = settingsDAO.getDateForDescription(description: "imei")!
        let fecha = Utils().FechaActual()
        
        let parameters: Parameters = [
            "comentarios": comentarios,
            "fotografia": foto,
            "imei": imei,
            "fecha": fecha,
            "latitud": latitud,
            "longitud": longitud,
            "latitudAlerta":latitud,
            "longitudAlerta": longitud
            ]
        
        restConnction.SendRequetService(url: Path.ALERTASOSPECHOSO.rawValue, body: parameters, secure: true, method: .post) { (response, error) in
            if error != nil{
                print("Ocurrio un error al validar el usuario: ", error!)
                completionHandler(nil,nil ,error)
                return
            }
            
            let estatus = response!["estatus"].int!
            var resperror = ""
            if(estatus == 0){
                resperror =  response!["error"].string!
                completionHandler(nil,resperror,nil)
                return
            }
            
            
            let response = ResponseGeneric(estatus: estatus, error: "")
            
            completionHandler(response,nil,nil)
        }
    }
    
    
    
    func RegisterDevice(latitud: Double,longitud: Double,imei: String, token: String,completionHandler: @escaping (ResponseGeneric?, Error?) -> ()){
        
        //Utils().showLoading(context: context)
        let imei = imei
        let fecha = Utils().FechaActual()
        
        let parameters: Parameters = [
            "tokenDispositivo": token,
            "imei": imei,
            "fecha": fecha,
            "latitud": latitud,
            "longitud": longitud,
            
        ]

        restConnction.SendRequetService(url: Path.REGISTERDEVICE.rawValue, body: parameters, secure: true, method: .post) { (response, error) in
            if error != nil{
                print("Ocurrio un error al validar el usuario: ", error!)
                completionHandler(nil, error)
                return
            }
            
            let estatus = response!["estatus"].int!
            let response = ResponseGeneric(estatus: estatus, error: "")
            
            completionHandler(response,nil)
        }
    }
    
    
    
    func ActualizarDireccion(context: UIViewController,latitud: Double ,longitud: Double ,iddireccion: Int, identificador: String,telefono: String,referencia: String,calle: String,numinterior: String,numexterior: String,colonia: String,ciudad: String,estado: String,cp:String,pais: String,completionHandler: @escaping (GenerarQrResponse?, Error?) -> ()){
        
        Utils().showLoading(context: context)
        let fecha = Utils().FechaActual()
        
        let parameters: Parameters = [
            "fecha": fecha,
            "latitud": latitud,
            "longitud": longitud,
            "direccion":["direccionid": iddireccion,
                        "identificador": identificador,
                         "telefono": telefono,
                         "referencia":referencia,
                         "calle": calle,
                         "noExt": numexterior,
                         "noInt": numinterior,
                         "colonia": colonia,
                         "municipio": estado,
                         "estadoId": 6,
                         "cp": cp,
                         "pais": pais ]
        ]
        restConnction.SendRequetService(url: Path.ACTUALIZARDIRECCION.rawValue, body: parameters, secure: true, method: .post) { (response, error) in
            if error != nil{
                print("Ocurrio un error al validar el usuario: ", error!)
                completionHandler(nil, error)
                return
            }
            //let error: String = response!["error"].string!
            /*let estatus = response!["estatus"].int!
             let codigoqr = response!["qr"].string!
             let qrResponse = GenerarQrResponse(estatus: estatus,qr: codigoqr)
             */
            print(response ?? "")
            
            completionHandler(nil,nil)
        }
    }
    
    
    func AgregarDirecciones(context: UIViewController,latitud: Double ,longitud: Double ,identificador: String,telefono: String,referencia: String,calle: String,numinterior: String,numexterior: String,colonia: String,ciudad: String,estado: String,cp:String,pais: String,completionHandler: @escaping (GenerarQrResponse?, Error?) -> ()){
        
        Utils().showLoading(context: context)
        let fecha = Utils().FechaActual()
        
         let parameters: Parameters = [
        "fecha": fecha,
        "latitud": latitud,
        "longitud": longitud,
        "direccion":["identificador": identificador,
        "telefono": telefono,
        "referencia":referencia,
        "calle": calle,
        "noExt": numexterior,
        "noInt": numinterior,
        "colonia": colonia,
        "municipio": estado,
        "estadoId": 6,
        "cp": cp,
        "pais": pais ]
        ]
        restConnction.SendRequetService(url: Path.AGREGARDIRECCION.rawValue, body: parameters, secure: true, method: .post) { (response, error) in
            if error != nil{
                print("Ocurrio un error al validar el usuario: ", error!)
                completionHandler(nil, error)
                return
            }
            //let error: String = response!["error"].string!
            /*let estatus = response!["estatus"].int!
            let codigoqr = response!["qr"].string!
            let qrResponse = GenerarQrResponse(estatus: estatus,qr: codigoqr)
            */
            print(response ?? "")
            
            completionHandler(nil,nil)
        }
    }
    
    
    func BotondePanico(context: UIViewController, latitud: Double, longitud: Double,completionHandler: @escaping (ResponseGeneric?,String?,Error?) -> ()){
        let imei = settingsDAO.getDateForDescription(description: "imei")
        let fecha = Utils().FechaActual()
        
        let parameters: Parameters = ["imei": imei ?? "",
                                      "fecha": fecha,
                                      "latitud": latitud,
                                      "longitud": longitud
        ]
        
        //Utils().showLoading(context: context)
        restConnction.SendRequetService(url: Path.BOTONPANICO.rawValue, body: parameters, secure: true, method: .post) { (response, error) in
            if error != nil{
                print("Ocurrio un error en el servicio: ", error!)
                completionHandler(nil,nil,error)
                return
            }
            
            
            let estatus = response!["estatus"].int!
            var resperror = ""
            if(estatus == 0){
                resperror =  response!["error"].string!
                completionHandler(nil,resperror,nil)
                return
            }

            let response = ResponseGeneric(estatus: estatus, error: resperror)
            
            completionHandler(response,nil,nil)
            
        }
    
    
    }
    
    
    func GenerateQR(context: UIViewController ,completionHandler: @escaping (GenerarQrResponse?, Error?) -> ()){
        
      Utils().showLoading(context: context)
        
      
      let imei = settingsDAO.getDateForDescription(description: "imei")
      let fecha = Utils().FechaActual()
        
      let parameters: Parameters = ["imei": imei ?? "",
                                    "fecha": fecha]
        
        restConnction.SendRequetService(url: Path.GENERARCODIGO.rawValue, body: parameters, secure: true, method: .post) { (response, error) in
            if error != nil{
                print("Ocurrio un error al validar el usuario: ", error!)
                completionHandler(nil, error)
                return
            }
            
            //let error: String = response!["error"].string!
            let estatus = response!["estatus"].int!
            let codigoqr = response!["qr"].string!
            
            
            let qrResponse = GenerarQrResponse(estatus: estatus,qr: codigoqr)
            
           
            
            print(response ?? "")
            
            completionHandler(qrResponse,nil)
            
            
        }
    
    }
    
    
    
    
    func GetEstados(completionHandler: @escaping (UserResponse?, Error?) -> ()){
        let parameters: Parameters = [:]
        
        
        restConnction.SendRequetService(url: Path.ESTADOS.rawValue, body: parameters, secure: true, method: .post) { (response, error) in
            if error != nil{
                print("Ocurrio un error al validar el usuario: ", error!)
                return
            }
            
            //let error: String = response!["error"].string!
            //let estatus: Int = response!["estatus"].int!
            let estados = response!["estados"].arrayValue
            
           // let loginResponse = LoginResponse(token: token, estatus: estatus)
            
            for estado in estados {
               //let auxestado = estado.dictionaryValue
               let estadoid = estado["estadoid"].int!
               let nombre = estado["nombre"].string!
               print(estadoid)
               print(nombre)
            }
            
            print(response ?? "")
            
            completionHandler(nil,nil)
            
            
        }
        
    
    }
    
    
    
    func AccessUser(latitud: Double,longitud: Double,imei:String,usuario: String, password: String, completionHandler: @escaping (LoginResponse?,String?, Error?) -> ()){
        
        let fecha = Utils().FechaActual()
  
        
        let parameters: Parameters = [
            "imei": imei,
            "fecha": fecha,
            "email": usuario,
            "password": password,
            "latitud": latitud,
            "longitud": longitud
        ]
        
        restConnction.SendRequetService(url: Path.ACCESS_USER.rawValue, body: parameters, secure: true, method: .post) { (response, error) in
            if error != nil{
                print("Ocurrio un error al validar el usuario: ", error.debugDescription)
                completionHandler(nil,nil,error)
                return
            }
            
            let estatus: Int = response!["estatus"].intValue
            
            if(estatus == 0){
                let resperror =  response!["error"].string!
                completionHandler(nil,resperror,nil)
                return
            }
            
            let token: String  = response!["token"].stringValue
            
            let nombre: String = response!["nombre"].stringValue
            
            
            let loginResponse = LoginResponse.init(token: token, estatus: estatus,nombre: nombre)
            
            completionHandler(loginResponse,nil,nil)
            
            //print(response ?? "")
            /*if response?.dictionaryObject?.count == nil
            {
                completionHandler(nil,response?.rawString(),nil)
            }
            else{
            let usuarioId: Int = response!["usuarioid"].intValue
            let rol_id: String = response!["rol_id"].string!
            let name: String = response!["name"].string!
            let middlename: String = response!["middlename"].string!
            let surname: String = response!["surname"].string!
            let email: String = response!["email"].string!
            
            let user = UserResponse(usuarioid: usuarioId,rol_id: rol_id,name: name,middlename: middlename,surname: surname,email: email)
            completionHandler(user, nil, nil)
            }*/
            
        }
    }
    
    
    
    func RegistroRedesSociales(email: String, nombre: String, apePaterno: String,apeMaterno: String,numCel: String,idSocial: String, social: String, imei: String, latitud: Double, longitud: Double, completionHandler: @escaping (LoginResponse?, Error?) -> ()){
        
        let fecha = Utils().FechaActual()
        
        let parameters: Parameters = [
            "email": email,
            "nombre": nombre,
            "apePaterno": apePaterno,
            "apeMaterno":apeMaterno,
            "idSocial": idSocial,
            "social": social,
            "imei": imei,
            "fecha": fecha,
            "latitud": latitud,
            "longitud": longitud
        ]
        
        
        RestConnection().SendRequetService(url: Path.REGISTRO_SOCIAL.rawValue, body: parameters, secure: true, method: .post) { (response, error) in
            if(error != nil){
                print("Ocurrio un error al obtener el registro: ", error!)
                completionHandler(nil,error)
                return
            }
            let estatus: Int = response!["estatus"].intValue
            
            if(estatus == 0){
                let resperror =  response!["error"].string!
                completionHandler(nil,resperror as? Error)
                return
            }
            
            let token: String = response!["token"].string!
            
            let loginResponse = LoginResponse(token: token, estatus: estatus)
            
            print(response ?? "")
            
            completionHandler(loginResponse,nil)
        }
        
    }
    
    func Registro(email: String, password: String,nombre: String, apePaterno: String,apeMaterno: String,numCel: String,idSocial: String, social: String, imei: String, latitud: Double, longitud: Double, completionHandler: @escaping (LoginResponse?, Error?) -> ()){
        
        let fecha = Utils().FechaActual()
       
        let parameters: Parameters = [
        "email": email,
        "password": password,
        "nombre": nombre,
        "numCel": numCel,
        "apePaterno": apePaterno,
        "apeMaterno":apeMaterno,
        "idSocial": idSocial,
        "social": social,
        "imei": imei,
        "fecha": fecha,
        "latitud": latitud,
        "longitud": longitud
        ]
        

        RestConnection().SendRequetService(url: Path.REGISTRO_SOCIAL.rawValue, body: parameters, secure: true, method: .post) { (response, error) in
            if(error != nil){
                print("Ocurrio un error al obtener el registro: ", error!)
                completionHandler(nil,error)
                return
            }
            let estatus: Int = response!["estatus"].intValue
            
            if(estatus == 0){
              let resperror =  response!["error"].string!
                completionHandler(nil,resperror as? Error)
                return
            }
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if(error != nil){
                    completionHandler(nil,error)
                    return
                }
            }
            
            let token: String = response!["token"].string!
            
            let loginResponse = LoginResponse(token: token, estatus: estatus)
            
          print(response ?? "")
            
         completionHandler(loginResponse,nil)
        }
    
    }

    
    func ServiceTest(usuario: String, isProfile: Bool, imei: String, completionHandler: @escaping (ShortProfileResponse?, Error?) -> ()){
        let parameters: Parameters = [
            "userId": usuario,
            "isProfile": isProfile,
            "imei": imei
        ]
        
        RestConnection().SendRequetService(url: Path.SERVICE_TEST.rawValue, body: parameters, secure: true, method: .post){ response, error in
            if error != nil
            {
                print("Ocurrio un error al obtener el short Profile: ", error!)
                return
            }
            
            
            //response?.stringValue
            
            //print(response!)
            //print(response?.stringValue)
            
            //if let object = ShortProfileResponse.deserialize(from: response) {
                // …
            //}
            
            let contact: Int = response!["contact"].intValue
            let existeRegistro: Int = response!["existeRegistro"].intValue
            let mySubscription: Int = response!["mySubscription"].intValue
            let name: String = response!["name"].string!
            let pitcher: Int = response!["pitcher"].intValue
            let publicProfile: Int = response!["publicProfile"].intValue
            let total: Int = response!["total"].intValue
            let visitaPerfil: Int = response!["visitaPerfil"].intValue
            
            let profile = ShortProfileResponse(contacto: contact, existeRegistro: existeRegistro, mySubscription: mySubscription, name: name, pitcher: pitcher, publicProfile: publicProfile, total: total, visitaPerfil: visitaPerfil)
            
            
            completionHandler(profile, nil)
        
        }
       
    }


}










