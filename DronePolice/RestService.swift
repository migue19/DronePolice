//
//  RestService.swift
//  followme
//
//  Created by Miguel Mexicano Herrera on 14/04/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import ConnectionLayer
import NutUtils
import Firebase
class RestService{
    let restConnction = RestConnection()
    let settingsDAO = SettingsDAO()
    
    func dowloadImage(url: String,completionHandler: @escaping (UIImage?,String?) -> ()){
        restConnction.MethodHTTPSecureImage(url: url, method: .get) { (response, error) in
            if(error != nil){
                completionHandler(nil,error)
                return
            }
            completionHandler(response,nil)
        }
    }
    
    func eliminarMiembro(latitud: Double,longitud: Double,id: Int,completionHandler: @escaping (ResponseGeneric?,String?,Error?) -> ()){
        //Utils().showLoading(context: context)
        let imei = settingsDAO.getDateForDescription(description: "imei")!
        let fecha = Utils().currentDate()
        
        let parameters: [String: Any] = [
            "imei": imei,
            "fecha": fecha,
            "latitud": latitud,
            "longitud": longitud,
            "id": id
        ]
        restConnction.SendRequetService(url: Path.ELIMINARMIEMBRO, body: parameters, secure: true, method: .post) { (response, error) in
            print(response ?? "algo")
            //            if error != nil{
            //                print("Ocurrio un error al validar el usuario: ", error!)
            //                completionHandler(nil,nil,error)
            //                return
            //            }
            //
            //            let estatus = response!["estatus"].int!
            //            var resperror = ""
            //            if(estatus == 0){
            //                resperror =  response!["error"].string!
            //                completionHandler(nil,resperror,nil)
            //                return
            //            }
            //
            //            let responseGeneric = ResponseGeneric.init(estatus: estatus, error: resperror)
            //
            //            completionHandler(responseGeneric,nil, nil)
        }
    }
    
    
    
    func AgregarMiembro(latitud: Double,longitud: Double,qr: String,tipo: Int,completionHandler: @escaping (ResponseGeneric?,String?,Error?) -> ()){
        
        //Utils().showLoading(context: context)
        let imei = settingsDAO.getDateForDescription(description: "imei")!
        let fecha = Utils().currentDate()
        
        let parameters: [String: Any]  = [
            "imei": imei,
            "fecha": fecha,
            "latitud": latitud,
            "longitud": longitud,
            "qr": qr,
            "tipo": tipo
        ]
        
        restConnction.SendRequetService(url: Path.AGREGARMIEMBRO, body: parameters, secure: true, method: .post) { (response, error) in
            print(response ?? "Algo")
            //            if error != nil{
            //                print("Ocurrio un error al validar el usuario: ", error!)
            //                completionHandler(nil,nil,error)
            //                return
            //            }
            //
            //            let estatus = response!["estatus"].int!
            //            var resperror = ""
            //            if(estatus == 0){
            //                resperror =  response!["error"].string!
            //                completionHandler(nil,resperror,nil)
            //                return
            //            }
            //
            //            let responseGeneric = ResponseGeneric.init(estatus: estatus, error: resperror)
            //
            //            completionHandler(responseGeneric,nil, nil)
        }
    }
    
    
    func ObtenerMiembrosFamiliares(latitud: Double,longitud: Double ,completionHandler: @escaping (MiembrosResponse?,String?,Error?) -> ()){
        let imei = settingsDAO.getDateForDescription(description: "imei")
        let fecha = Utils().currentDate()
        
        let parameters: [String: Any]  = [
            "imei": imei.valueOrEmpty,
            "fecha": fecha,
            "latitud": latitud,
            "longitud": longitud,
        ]
        restConnction.SendRequetService(url: Path.MIEMBROSFAMILIARES, body: parameters, secure: true, method: .post) { (response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Ocurrio un error al validar el usuario: ", error)
                    completionHandler(nil, error, nil)
                    return
                }
                guard let data = response else {
                    return
                }
                if let entity = Utils.decode(MiembrosResponse.self, from: data, serviceName: "members_service".localized) {
                    if let error = entity.error, error != "" {
                        completionHandler(nil, error, nil)
                        return
                    }
                    if(entity.estatus == 0){
                        let resperror = entity.error
                        completionHandler(nil,resperror, nil)
                        return
                    }
                    completionHandler(entity, nil, nil)
                } else {
                    let error = "decode_error".localized
                    completionHandler(nil, error, nil)
                }
            }
        }
    }
    
    
    func ObtenerMiembrosVecinos(latitud: Double,longitud: Double ,completionHandler: @escaping (MiembrosResponse?,String?,Error?) -> ()) {
        let imei = settingsDAO.getDateForDescription(description: "imei")!
        let fecha = Utils().currentDate()
        let parameters: [String: Any]  = [
            "imei": imei,
            "fecha": fecha,
            "latitud": latitud,
            "longitud": longitud,
        ]
        restConnction.SendRequetService(url: Path.MIEMBROSVECINOS, body: parameters, secure: true, method: .post) { (response, error) in
            DispatchQueue.main.async {
                if let error = error, error != "" {
                    print("Ocurrio un error al validar el usuario: ", error)
                    completionHandler(nil, error, nil)
                    return
                }
                guard let data = response else {
                    return
                }
                if let entity = Utils.decode(MiembrosResponse.self, from: data, serviceName: "members_service".localized) {
                    if let error = entity.error, error != "" {
                        completionHandler(nil, error, nil)
                        return
                    }
                    if(entity.estatus == 0){
                        let resperror = entity.error
                        completionHandler(nil,resperror, nil)
                        return
                    }
                    completionHandler(entity, nil, nil)
                } else {
                    let error = "decode_error".localized
                    completionHandler(nil, error, nil)
                }
            }
        }
    }
    
    
    
    
    
    
    func ObtenerDirecciones(context: UIViewController,latitud: Double,longitud: Double ,completionHandler: @escaping (DireccionResponse?,String?,Error?) -> ()){
        let imei = settingsDAO.getDateForDescription(description: "imei")!
        let fecha = Utils().currentDate()
        
        let parameters: [String: Any]  = [
            "imei": imei,
            "fecha": fecha,
            "latitud": latitud,
            "longitud": longitud,
        ]
        
        restConnction.SendRequetService(url: Path.OBTENERDIRECCIONES, body: parameters, secure: true, method: .post) { (response, error) in
            DispatchQueue.main.async {
                if let error = error, error != "" {
                    print("Ocurrio un error al validar el usuario: ", error)
                    completionHandler(nil, error, nil)
                    return
                }
                guard let data = response else {
                    return
                }
                if let entity = Utils.decode(DireccionResponse.self, from: data, serviceName: "members_service".localized) {
                    if let error = entity.error, error != "" {
                        completionHandler(nil, error, nil)
                        return
                    }
                    if(entity.estatus == 0){
                        let resperror = entity.error
                        completionHandler(nil,resperror, nil)
                        return
                    }
                    completionHandler(entity, nil, nil)
                } else {
                    let error = "decode_error".localized
                    completionHandler(nil, error, nil)
                }
            }
        }
    }
    
    
    
    
    
    func EnviarSospechoso(comentarios: String, foto: String,latitud: Double, longitud: Double , latitudAlerta: Double,longitudAlerta: Double,completionHandler: @escaping (ResponseGeneric?,String? ,Error?) -> ()){
        
        //Utils().showLoading(context: context)
        let imei = settingsDAO.getDateForDescription(description: "imei")!
        let fecha = Utils().currentDate()
        
        let parameters: [String: Any] = [
            "comentarios": comentarios,
            "fotografia": foto,
            "imei": imei,
            "fecha": fecha,
            "latitud": latitud,
            "longitud": longitud,
            "latitudAlerta":latitudAlerta,
            "longitudAlerta": longitudAlerta
        ]
        
        restConnction.SendRequetService(url: Path.ALERTASOSPECHOSO, body: parameters, secure: true, method: .post) { (response, error) in
            print(response ?? "Algo")
            //            if error != nil{
            //                print("Ocurrio un error al validar el usuario: ", error!)
            //                completionHandler(nil,nil ,error)
            //                return
            //            }
            //
            //            let estatus = response!["estatus"].int!
            //            var resperror = ""
            //            if(estatus == 0){
            //                resperror =  response!["error"].string!
            //                completionHandler(nil,resperror,nil)
            //                return
            //            }
            //
            //
            //            let response = ResponseGeneric(estatus: estatus, error: "")
            //
            //            completionHandler(response,nil,nil)
        }
    }
    
    
    
    func RegisterDevice(latitud: Double, longitud: Double, imei: String, token: String, completionHandler: @escaping (ResponseGeneric?, String?) -> ()) {
        let imei = imei
        let fecha = Utils().currentDate()
        let parameters: [String: Any] = [
            "tokenDispositivo": token,
            "imei": imei,
            "fecha": fecha,
            "latitud": latitud,
            "longitud": longitud,
        ]
        restConnction.SendRequetService(url: Path.REGISTERDEVICE, body: parameters, secure: true, method: .post) { (response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Ocurrio un error al validar el usuario: ", error)
                    completionHandler(nil, error)
                    return
                }
                guard let data = response else {
                    return
                }
                if let entity = Utils.decode(LoginResponse.self, from: data, serviceName: "register_service".localized) {
                    if let error = entity.error {
                        completionHandler(nil, error)
                        return
                    }
                    if(entity.estatus == 0){
                        let resperror = entity.error
                        completionHandler(nil,resperror)
                        return
                    }
                    let response = ResponseGeneric(estatus: entity.estatus.valueOrZero, error: "")
                    completionHandler(response, nil)
                } else {
                    let error = "decode_error".localized
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    
    
    func ActualizarDireccion(context: UIViewController,latitud: Double ,longitud: Double,latitudDir: Double, longitudDir: Double,iddireccion: Int, identificador: String,telefono: String,referencia: String,calle: String,numinterior: String,numexterior: String,colonia: String,ciudad: String,estadoId: Int,cp:String,pais: String,eliminar: Bool,completionHandler: @escaping (ResponseGeneric?,String? ,Error?) -> ()){
        
        Utils().showLoading(context: context)
        let fecha = Utils().currentDate()
        
        let parameters: [String: Any] = [
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
                         "latitud": latitudDir,
                         "longitud": longitudDir,
                         "municipio": ciudad,
                         "estadoId": estadoId,
                         "cp": cp,
                         "pais": pais ],
            "eliminar": eliminar
        ]
        restConnction.SendRequetService(url: Path.ACTUALIZARDIRECCION, body: parameters, secure: true, method: .post) { (response, error) in
            print(response ?? "Algo")
            //            if error != nil{
            //                print("Ocurrio un error al validar el usuario: ", error!)
            //                completionHandler(nil,nil ,error)
            //                return
            //            }
            //
            //            let estatus = response!["estatus"].int!
            //            var resperror = ""
            //            if(estatus == 0){
            //                resperror =  response!["error"].string!
            //                completionHandler(nil,resperror,nil)
            //                return
            //            }
            //
            //            let response = ResponseGeneric(estatus: estatus, error: resperror)
            //
            //            completionHandler(response,nil,nil)
            
        }
    }
    
    
    func AgregarDirecciones(context: UIViewController,latitud: Double ,longitud: Double,latitudDir:Double,longitudDir: Double,identificador: String,telefono: String,referencia: String,calle: String,numinterior: String,numexterior: String,colonia: String,ciudad: String,estadoId: Int,cp:String,pais: String,completionHandler: @escaping (ResponseGeneric?,String? ,Error?) -> ()){
        
        Utils().showLoading(context: context)
        let fecha = Utils().currentDate()
        
        let parameters: [String: Any] = [
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
                         "latitud": latitudDir,
                         "longitud": longitudDir,
                         "municipio": ciudad,
                         "estadoId": estadoId,
                         "cp": cp,
                         "pais": pais ]
        ]
        restConnction.SendRequetService(url: Path.AGREGARDIRECCION, body: parameters, secure: true, method: .post) { (response, error) in
            print(response ?? "Algo")
            //            if error != nil{
            //                print("Ocurrio un error al validar el usuario: ", error!)
            //                completionHandler(nil,nil,error)
            //                return
            //            }
            //
            //            let estatus = response!["estatus"].int!
            //            var resperror = ""
            //            if(estatus == 0){
            //                resperror =  response!["error"].string!
            //                completionHandler(nil,resperror,nil)
            //                return
            //            }
            //
            //            let responseGeneric = ResponseGeneric.init(estatus: estatus, error: resperror)
            //
            //            completionHandler(responseGeneric,nil, nil)
        }
    }
    
    
    func BotondePanico(context: UIViewController, latitud: Double, longitud: Double,completionHandler: @escaping (ResponseGeneric?,String?,Error?) -> ()){
        let imei = settingsDAO.getDateForDescription(description: "imei")
        let fecha = Utils().currentDate()
        
        let parameters: [String: Any]  = ["imei": imei ?? "",
                                          "fecha": fecha,
                                          "latitud": latitud,
                                          "longitud": longitud
        ]
        
        //Utils().showLoading(context: context)
        restConnction.SendRequetService(url: Path.BOTONPANICO, body: parameters, secure: true, method: .post) { (response, error) in
            print(response ?? "Algo")
            //            if error != nil{
            //                print("Ocurrio un error en el servicio: ", error!)
            //                completionHandler(nil,nil,error)
            //                return
            //            }
            //
            //
            //            let estatus = response!["estatus"].int!
            //            var resperror = ""
            //            if(estatus == 0){
            //                resperror =  response!["error"].string!
            //                completionHandler(nil,resperror,nil)
            //                return
            //            }
            //
            //            let response = ResponseGeneric(estatus: estatus, error: resperror)
            //
            //            completionHandler(response,nil,nil)
        }
    }
    
    
    func GenerateQR(context: UIViewController ,completionHandler: @escaping (GenerarQrResponse?, Error?) -> ()){
        Utils().showLoading(context: context)
        let imei = settingsDAO.getDateForDescription(description: "imei")
        let fecha = Utils().currentDate()
        let parameters: [String: Any] = [
            "imei": imei ?? "",
            "fecha": fecha
        ]
        restConnction.SendRequetService(url: Path.GENERARCODIGO, body: parameters, secure: true, method: .post) { (response, error) in
            guard let data = response else {
                return
            }
            do {
                let response = try JSONDecoder().decode(QRServiceResponse.self, from: data)
                if response.estatus == 0 {
                    let qrResponse = GenerarQrResponse(estatus: response.estatus,qr: response.qr)
                    DispatchQueue.main.async {
                        completionHandler(qrResponse,nil)
                    }
                } else {
                    let error: Error = NSError(domain: "service Error", code: -1, userInfo: nil)
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    
    
    
    func GetEstados(completionHandler: @escaping (EstadosResponse?,String? ,Error?) -> ()){
        let parameters: [String: Any] = [:]
        
        
        restConnction.SendRequetService(url: Path.ESTADOS, body: parameters, secure: true, method: .post) { (response, error) in
            print(response ?? "Algo")
            //            if error != nil{
            //                print("Ocurrio un error al validar el usuario: ", error!)
            //                return
            //            }
            //
            //            let estatus: Int = response!["estatus"].intValue
            //
            //
            //            var resperror = ""
            //            if(estatus == 0){
            //                resperror =  response!["error"].string!
            //                completionHandler(nil,resperror,nil)
            //                return
            //            }
            //
            //
            //            let estados = response!["estados"].arrayValue
            //
            //           // let loginResponse = LoginResponse(token: token, estatus: estatus)
            //
            //            var arrayEstado = [Estado]()
            //
            //            for estado in estados {
            //               //let auxestado = estado.dictionaryValue
            //               let estadoid = estado["estadoid"].int!
            //               let nombre = estado["nombre"].string!
            //
            //                let auxEstados = Estado.init(estadoid: estadoid, nombre: nombre)
            //
            //                arrayEstado.append(auxEstados)
            //
            //            }
            //
            //
            //            let estadoResponse = EstadosResponse.init(estatus: estatus, error: resperror, estados: arrayEstado)
            //
            //
            //
            //            completionHandler(estadoResponse,nil, nil)
            
            
        }
        
        
    }
    func AccessUser(request: LoginRequest, completionHandler: @escaping (LoginResponse?,String?, Error?) -> ()){
        let fecha = Utils().currentDate()
        let parameters: [String: Any]  = [
            "imei": request.imei,
            "fecha": fecha,
            "email": request.user,
            "password": request.password.md5(),
            "latitud": request.latitude,
            "longitud": request.longitude
        ]
        restConnction.SendRequetService(url: Path.ACCESS_USER, body: parameters, secure: true, method: .post) { (response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Ocurrio un error al obtener el registro: ", error)
                    completionHandler(nil, error, nil)
                    return
                }
                guard let data = response else {
                    return
                }
                if let entity = Utils.decode(LoginResponse.self, from: data, serviceName: "register_service".localized) {
                    if let error = entity.error {
                        completionHandler(nil, error, nil)
                        return
                    }
                    if(entity.estatus == 0){
                        let resperror = entity.error
                        completionHandler(nil,resperror,nil)
                        return
                    }
                    completionHandler(entity, nil, nil)
                } else {
                    let error = "decode_error".localized
                    completionHandler(nil, error, nil)
                }
            }
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
    
    
    
    func RegistroRedesSociales(request: SocialLoginRequest, completionHandler: @escaping (LoginResponse?, Error?) -> ()){
        let fecha = Utils().currentDate()
        let parameters: [String: Any] = [
            "email": request.email,
            "nombre": request.name,
            "apePaterno": request.apePaterno,
            "apeMaterno":request.apeMaterno,
            "idSocial": request.idSocial,
            "social": request.social,
            "imei": request.imei,
            "fecha": fecha,
            "latitud": request.latitud,
            "longitud": request.longitud
        ]
        RestConnection().SendRequetService(url: Path.REGISTRO_SOCIAL, body: parameters, secure: true, method: .post) { (response, error) in
            guard let data = response else {
                return
            }
            do {
                let response = try JSONDecoder().decode(SocialLoginResponse.self, from: data)
                if response.estatus == 1 {
                    let loginResponse = LoginResponse(estatus: response.estatus, error: nil, token: response.token, nombre: nil)
                    completionHandler(loginResponse,nil)
                } else {
                    let error: Error = NSError(domain: "service Error", code: -1, userInfo: nil)
                    completionHandler(nil, error)
                }
            } catch {
                completionHandler(nil, error)
            }
        }
    }
    
    func Registro(email: String, password: String,nombre: String, apePaterno: String,apeMaterno: String,numCel: String,idSocial: String, social: String, imei: String, latitud: Double, longitud: Double, completion: @escaping (RegisterResponse?, String?) -> ()){
        let fecha = Utils().currentDate()
        let parameters: [String: Any] = [
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
        executeRegister(email: email, password: password, parameters: parameters, completionHandler: completion)
    }
    func executeRegister(email: String, password: String,parameters: [String: Any], completionHandler: @escaping (RegisterResponse?, String?) -> ()) {
        restConnction.SendRequetService(url: Path.REGISTRO_SOCIAL, body: parameters, secure: true, method: .post) { (response, error) in
            if let error = error {
                print("Ocurrio un error al obtener el registro: ", error)
                completionHandler(nil, error)
                return
            }
            guard let response = response else {
                return
            }
            if let entity = Utils.decode(RegisterResponse.self, from: response, serviceName: "register_service".localized) {
                if let error = entity.error {
                    completionHandler(nil, error)
                    return
                }
                if(entity.estatus == 0){
                    let resperror = entity.error
                    completionHandler(nil,resperror)
                    return
                }
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if(error != nil){
                        completionHandler(nil, error?.localizedDescription)
                        return
                    }
                }
                completionHandler(entity, nil)
            } else {
                let error = "decode_error".localized
                completionHandler(nil, error)
            }
        }
    }
    func ServiceTest(usuario: String, isProfile: Bool, imei: String, completionHandler: @escaping (ShortProfileResponse?, Error?) -> ()){
        let parameters: [String: Any] = [
            "userId": usuario,
            "isProfile": isProfile,
            "imei": imei
        ]
        
        RestConnection().SendRequetService(url: Path.SERVICE_TEST, body: parameters, secure: true, method: .post){ response, error in
            print(response ?? "Algo")
            //            if error != nil
            //            {
            //                print("Ocurrio un error al obtener el short Profile: ", error!)
            //                return
            //            }
            //
            //
            //            //response?.stringValue
            //
            //            //print(response!)
            //            //print(response?.stringValue)
            //
            //            //if let object = ShortProfileResponse.deserialize(from: response) {
            //                // …
            //            //}
            //
            //            let contact: Int = response!["contact"].intValue
            //            let existeRegistro: Int = response!["existeRegistro"].intValue
            //            let mySubscription: Int = response!["mySubscription"].intValue
            //            let name: String = response!["name"].string!
            //            let pitcher: Int = response!["pitcher"].intValue
            //            let publicProfile: Int = response!["publicProfile"].intValue
            //            let total: Int = response!["total"].intValue
            //            let visitaPerfil: Int = response!["visitaPerfil"].intValue
            //
            //            let profile = ShortProfileResponse(contacto: contact, existeRegistro: existeRegistro, mySubscription: mySubscription, name: name, pitcher: pitcher, publicProfile: publicProfile, total: total, visitaPerfil: visitaPerfil)
            //
            //
            //            completionHandler(profile, nil)
            
        }
        
    }
    
    
}










