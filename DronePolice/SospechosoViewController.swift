//
//  SospechosoViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 09/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import CoreLocation

class SospechosoViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,LocationServiceDelegate{//,CLLocationManagerDelegate {
    @IBOutlet weak var imageSospechoso: UIImageView!
    let picker = UIImagePickerController()
    @IBOutlet weak var comentario: UITextField!
    //let locationManager = CLLocationManager()
    //var currentLocation: CLLocation! = nil
    var longitud = 0.0
    var latitud = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils().setGradientBackground(context: self)
        LocationService.sharedInstance.delegate = self
        LocationService.sharedInstance.startUpdatingLocation()
        /*locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startMonitoringSignificantLocationChanges()*/
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageSospechoso.isUserInteractionEnabled = true
        imageSospechoso.addGestureRecognizer(tapGestureRecognizer)
        
        picker.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        //locationAuthStatus()
        LocationService.sharedInstance.startUpdatingLocation()
    }
    
    /*func locationAuthStatus(){
        
        let estatus = CLLocationManager.authorizationStatus()
        
        if estatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        if estatus == .denied || estatus == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        locationManager.startUpdatingLocation()
        
    }*/
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }

    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No se encontro Camara",
            message: "El dispositivo no cuenta con camara",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        //imageSospechoso.contentMode = .scaleAspectFit //3
        
        imageSospechoso.clipsToBounds = true
        imageSospechoso.layer.borderColor = UIColor.red.cgColor
        imageSospechoso.layer.borderWidth = 3
        imageSospechoso.layer.cornerRadius = imageSospechoso.layer.bounds.height/2
        
        imageSospechoso.image = chosenImage //4
        
        dismiss(animated:true, completion: nil)

    }
    
    

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func AlertaSospechoso(_ sender: Any) {
        if(comentario.text == ""){
           Utils().alerta(context: self, title: "Comentario Vacio", mensaje: "No puede ir el comentario vacio")
            return
        }
        if (imageSospechoso.image == UIImage(named: "Foto")){
            Utils().alerta(context: self, title: "Imagen Vacia", mensaje: "La imagen no puede ser nula")
            return
        }
        
        
        let imageBase64 = Utils().convertImageToBase64(image: imageSospechoso.image!)
        
        
        if(latitud == 0 || longitud == 0 ){
            Utils().alerta(context: self, title: "Error de Ubicacion", mensaje: "No se puede obtener la Ubicacion")
        }else{
            RestService().EnviarSospechoso(comentarios: comentario.text!, foto: imageBase64, latitud: latitud, longitud: longitud) { (response,stringresponse ,error) in
                if(error != nil){
                    Utils().alerta(context: self, title: "Error en el Servicio", mensaje: error.debugDescription)
                    return
                }
                if(stringresponse != nil){
                    Utils().alerta(context: self, title: "Error", mensaje: stringresponse!)
                   return
                }
                
                if(response?.estatus == 1){
                  Utils().alerta(context: self, title: "Exitoso", mensaje: "Sospechoso enviado correctamente")
                }
                
                print(response?.estatus ?? "")
            }
        }
    }

    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    // MARK: LocationService Delegate
    func tracingLocation(_ currentLocation: CLLocation) {
        latitud = currentLocation.coordinate.latitude
        longitud = currentLocation.coordinate.longitude
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        print("tracing Location Error : \(error.description)")
    }
    
}
