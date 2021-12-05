//
//  RegistroViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 15/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import Firebase

class RegistroViewController: BaseViewController {
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apePaterno: UITextField!
    @IBOutlet weak var apeMaterno: UITextField!
    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var contraseña: UITextField!
    @IBOutlet weak var repetirContraseña: UITextField!
    let uuid = UUID().uuidString
    var latitud = 0.0
    var longitud = 0.0
    var restService = RestService()
    let settingsDAO = SettingsDAO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Registro(_ sender: Any) {
        if(nombre.text! == "" || apePaterno.text! == "" || apeMaterno.text! == "" || telefono.text! == "" || email.text! == "" || contraseña.text! == "" || repetirContraseña.text! == ""){
            Utils().alerta(context: self, title: "Error", mensaje: "Los campos son obligatorios")
            return
        }
        if(contraseña.text != repetirContraseña.text){
            Utils().alerta(context: self, title: "Error", mensaje: "Las contraseñas deben ser iguales")
            return
        }
        showHUD()
        restService.Registro(email: email.text!, password: contraseña.text!, nombre: nombre.text!, apePaterno: apePaterno.text!, apeMaterno: apeMaterno.text!, numCel: telefono.text!, idSocial: email.text!, social: "", imei: uuid, latitud: latitud, longitud: longitud) { (response, error) in
            self.hideHUD()
            if(error != nil){
                Utils().alerta(context: self, title: "Error en el Servidor", mensaje: error.debugDescription)
                return
            }
            let token = response?.token
            if(token == nil){
                Utils().alerta(context: self, title: "Error en el Servidor", mensaje: "Error al registrar cliente.")
                return
            }
            let estatus = response?.estatus
            Auth.auth().createUser(withEmail: self.email.text!, password: self.contraseña.text!) { (user, error) in
                
                if(error != nil){
                    Utils().alerta(context: self, title: "Error Firebase", mensaje: error.debugDescription)
                }
                
            }
            if(estatus == 1){
                Utils().alerta(context: self, title: "Registro Exitoso", mensaje: "El registro fue correcto")
            }
        }
    }
}
