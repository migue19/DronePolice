//
//  AgregarDireccionesViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 08/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import CoreLocation
class AgregarDireccionesViewController: UIViewController,LocationServiceDelegate  {
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
    var direccion: Direccion = Direccion()

    override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.sharedInstance.delegate = self
        LocationService.sharedInstance.startUpdatingLocation()
       
        identificador.text = direccion.identificador
        telefono.text = direccion.telefono
        referencia.text = direccion.referencia
        calle.text = direccion.calle
        colonia.text = direccion.colonia
        //Ciudad.text = direccion.municipio
        estado.text = direccion.municipio
        cp.text = direccion.cp
        pais.text = direccion.pais
        
        if(direccion.direccionid != 0){
        registro.setTitle("Actualizar", for: .normal)
        }
        
        
        self.navigationController?.navigationBar.tintColor = Utils().colorPrincipal
         self.navigationController?.navigationBar.backItem?.title = " "
        
        
        self.title = "REGISTRO"
    
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: Utils().colorPrincipal]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        
        //self.navigationBar.tintColor = Utils().colorPrincipal
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
    
    @IBAction func registrarDireccion(_ sender: Any) {
        if identificador.text == "" || telefono.text == "" ||  referencia.text == "" || calle.text == "" || numexterior.text == "" || numInterior.text == "" || colonia.text == "" || Ciudad.text == "" || estado.text == "" || cp.text == "" || pais.text == ""{
            Utils().alerta(context: self, title: "Error", mensaje: "Todos los campos son obligatorios")
        return
        }
        if(latitud == 0 || longitud == 0 ){
            Utils().alerta(context: self, title: "Error de Ubicacion", mensaje: "No se puede obtener la Ubicacion")
            return
        }
        
        
        if(direccion.direccionid == 0){
            RestService().AgregarDirecciones(context: self, latitud: latitud, longitud: longitud, identificador: identificador.text!, telefono: telefono.text!, referencia: referencia.text!, calle: calle.text!, numinterior: numInterior.text!, numexterior: numexterior.text!, colonia: colonia.text!, ciudad: Ciudad.text!, estado: estado.text!, cp: cp.text!, pais: pais.text!) { (response, error) in
            
            self.dismiss(animated: true, completion: nil)

            
            print("hola")
            }
        }
        else{
            RestService().ActualizarDireccion(context: self, latitud: latitud, longitud: longitud, iddireccion: direccion.direccionid, identificador: identificador.text!, telefono: telefono.text!, referencia: referencia.text!, calle: calle.text!, numinterior: numInterior.text!, numexterior: numexterior.text!, colonia: colonia.text!, ciudad: Ciudad.text!, estado: estado.text!, cp: cp.text!, pais: pais.text!, completionHandler: { (response, error) in
                
                
                self.dismiss(animated: true, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
