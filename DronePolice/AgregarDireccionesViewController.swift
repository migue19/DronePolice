//
//  AgregarDireccionesViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 08/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import CoreLocation
class AgregarDireccionesViewController: UIViewController,LocationServiceDelegate,PopupLocalizacionProtocolo,PopupEstadoProtocolo,UITextFieldDelegate{
    @IBOutlet weak var identificador: UITextField!
    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var referencia: UITextField!
    @IBOutlet weak var calle: UITextField!
    @IBOutlet weak var numexterior: UITextField!
    @IBOutlet weak var numInterior: UITextField!
    @IBOutlet weak var colonia: UITextField!
    @IBOutlet weak var Ciudad: UITextField!
    @IBOutlet weak var estado: UITextField!
    @IBOutlet weak var cp: UITextField!
    @IBOutlet weak var pais: UITextField!
    @IBOutlet weak var registro: CustomButton!
    
    var latitud = 0.0
    var longitud = 0.0
    var latitudDireccion = 0.0
    var longitudDireccion = 0.0
    var direccion: Direccion = Direccion()
    var Auxestado = Estado()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.sharedInstance.delegate = self
        LocationService.sharedInstance.startUpdatingLocation()
        
        identificador.delegate = self
        telefono.delegate = self
        referencia.delegate = self
        calle.delegate = self
        colonia.delegate = self
        Ciudad.delegate = self
        cp.delegate = self
        pais.delegate = self
        numexterior.delegate = self
        numInterior.delegate = self
       
        identificador.text = direccion.identificador
        telefono.text = direccion.telefono
        referencia.text = direccion.referencia
        calle.text = direccion.calle
        colonia.text = direccion.colonia
        Ciudad.text = direccion.municipio
        //estado.text = direccion.municipio
        cp.text = direccion.cp
        pais.text = direccion.pais
        numexterior.text = direccion.noExt
        numInterior.text = direccion.noInt
        
        if(direccion.direccionid != 0){
            registro.setTitle("Actualizar", for: .normal)
        }
        else{
            pais.text = "México"
        }
        
        
        self.navigationController?.navigationBar.tintColor = Utils().colorPrincipal
         self.navigationController?.navigationBar.backItem?.title = " "
        
        
        self.title = "REGISTRO"
    
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: Utils().colorPrincipal]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func registrarDireccion(_ sender: Any) {
        if identificador.text == "" || telefono.text == "" ||  referencia.text == "" || calle.text == "" || numexterior.text == "" || colonia.text == "" || Ciudad.text == "" || estado.text == "" || cp.text == "" || pais.text == ""{
            Utils().alerta(context: self, title: "Error", mensaje: "Los campos con * son obligatorios")
        return
        }
        if(latitud == 0 || longitud == 0 ){
            Utils().alerta(context: self, title: "Error de Ubicacion", mensaje: "No se puede obtener la Ubicacion")
            return
        }
        
        
        if(direccion.direccionid == 0){
            RestService().AgregarDirecciones(context: self, latitud: latitud, longitud: longitud,latitudDir: latitudDireccion, longitudDir: longitudDireccion,identificador: identificador.text!, telefono: telefono.text!, referencia: referencia.text!, calle: calle.text!, numinterior: numInterior.text!, numexterior: numexterior.text!, colonia: colonia.text!, ciudad: Ciudad.text!, estadoId: Auxestado.estadoid, cp: cp.text!, pais: pais.text!) { (response,stringresponse ,error) in
            
                self.dismiss(animated: true, completion: nil)

                if(error != nil){
                    Utils().alerta(context: self, title: "Error en el servidor", mensaje: error.debugDescription)
                    return
                }
                if(stringresponse != nil){
                    Utils().alerta(context: self, title: "Error", mensaje: stringresponse!)
                    return
                }
                
                if(response?.estatus == 1){
                    Utils().alerta(context: self, title: "Exito", mensaje: "Se Agrego Correctamente la Direccion")
                }
                self.navigationController?.popViewController(animated: true)
            
            }
        }
        else{
            RestService().ActualizarDireccion(context: self, latitud: latitud, longitud: longitud, latitudDir: latitudDireccion, longitudDir: longitudDireccion, iddireccion: direccion.direccionid, identificador: identificador.text!, telefono: telefono.text!, referencia: referencia.text!, calle: calle.text!, numinterior: numInterior.text!, numexterior: numexterior.text!, colonia: colonia.text!, ciudad: Ciudad.text!, estadoId: Auxestado.estadoid, cp: cp.text!, pais: pais.text!, eliminar: false, completionHandler: { (response,stringresponse ,error) in
                
                self.dismiss(animated: true, completion: nil)
                
                if(error != nil){
                    Utils().alerta(context: self, title: "Error en el servidor", mensaje: error.debugDescription)
                    return
                }
                if(stringresponse != nil){
                    Utils().alerta(context: self, title: "Error", mensaje: stringresponse!)
                    return
                }
                
                if(response?.estatus == 1){
                    Utils().alerta(context: self, title: "Exito", mensaje: "Se Actualizo Correctamente la Direccion")
                    
                }
                
             self.navigationController?.popViewController(animated: true)
                
            })
        }
        
    }
    
    // MARK: LocationService Delegate
    func tracingLocation(_ currentLocation: CLLocation) {
        latitud = currentLocation.coordinate.latitude
        longitud = currentLocation.coordinate.longitude
 
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        print("tracing Location Error : \(error.description)")
    }
    
    @IBAction func EliminarDirecciones(_ sender: Any) {
        RestService().ActualizarDireccion(context: self, latitud: latitud, longitud: longitud, latitudDir: latitudDireccion, longitudDir: longitudDireccion, iddireccion: direccion.direccionid, identificador: identificador.text!, telefono: telefono.text!, referencia: referencia.text!, calle: calle.text!, numinterior: numInterior.text!, numexterior: numexterior.text!, colonia: colonia.text!, ciudad: Ciudad.text!, estadoId: Auxestado.estadoid, cp: cp.text!, pais: pais.text!, eliminar: true, completionHandler: { (response,stringresponse ,error) in
            
            self.dismiss(animated: true, completion: nil)
            
            if(error != nil){
                Utils().alerta(context: self, title: "Error en el servidor", mensaje: error.debugDescription)
                return
            }
            if(stringresponse != nil){
                Utils().alerta(context: self, title: "Error", mensaje: stringresponse!)
                return
            }
            
            if(response?.estatus == 1){
                Utils().alerta(context: self, title: "Exito", mensaje: "Se Actualizo Correctamente la Direccion")
            }
            
            self.navigationController?.popViewController(animated: true)
        })
        
    }
    
    
    
    func muestraDireccion(calleString: String, numero: String, ciudad: String, codigoPostal: String, estadoString: String,latitudDir: Double,longitudDir: Double)
    {
        calle.text = calleString
        numexterior.text = numero
        Ciudad.text = ciudad
        estado.text = estadoString
        cp.text = codigoPostal
        latitudDireccion = latitudDir
        longitudDireccion = longitudDir
        print("Listo")
        
    }
    
    
    func muestraEstado(estadoAux: Estado) {
        Auxestado = estadoAux
        estado.text = estadoAux.nombre
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popLocalizacion"
        {
            let popup = segue.destination as! LocalizacionViewController
            popup.popUpVC = self
        }
        
        if segue.identifier == "popUpEstado"
        {
            let popup = segue.destination as! EstadosViewController
            popup.popUpVC = self
        }
        
        
        
    }
    
   
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
   
    
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
