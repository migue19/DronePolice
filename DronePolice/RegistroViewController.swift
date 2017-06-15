//
//  RegistroViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 15/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import Firebase

class RegistroViewController: UIViewController {
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func Registro(_ sender: Any) {
        if(nombre.text! == "" || apePaterno.text! == "" || apeMaterno.text! == "" || telefono.text! == "" || email.text! == "" || contraseña.text! == "" || repetirContraseña.text! == ""){
        Utils().alerta(context: self, title: "Errror", mensaje: "Los campos son obligatorios")
            return
        }
        
        restService.RegistroRedesSociales(email: email.text!, nombre: nombre.text!, apePaterno: apePaterno.text!, apeMaterno: apeMaterno.text!, numCel: "", idSocial: email.text!, social: "", imei: uuid, latitud: latitud, longitud: longitud) { (response, error) in
            
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
            
            
            
            let tokenfirebase = FIRInstanceID.instanceID().token()
            //FirebaseInstanceId.getInstance().getToken()
            /////servico registro device
            
            RestService().RegisterDevice(latitud: self.latitud, longitud: self.longitud, imei: self.uuid,token: tokenfirebase!, completionHandler: { (respose, error) in
                if(error != nil){
                    Utils().alerta(context: self, title: "Error en el Servidor", mensaje: error.debugDescription)
                    return
                }
                
                self.settingsDAO.insertUserInDB(idUser: "", token: token!, estatus: estatus!, name: self.nombre.text!, firstName: self.apePaterno.text!, lastName: self.apeMaterno.text!, email: self.email.text!, urlImage: "", imei: self.uuid)
                
                //self.downloadImage(url: urlimage)
                
                self.settingsDAO.getData()
                print(respose ?? "error")
                
                self.dismiss(animated: true, completion: nil)
                /*self.nombre.text = ""
                self.apeMaterno.text = ""
                self.apePaterno.text = ""
                self.telefono.text = ""
                self.email.text = ""
                self.contraseña.text = ""
                self.repetirContraseña.text = ""*/
                
                
            })
            
            
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
