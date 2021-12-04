//
//  BotonPanicoUiViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 30/05/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import CoreLocation

class BotonPanicoUiViewController: UIViewController,LocationServiceDelegate{
    var restService = RestService()
    var settingDAO = SettingsDAO()
    var longitud = 0.0
    var latitud = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground()
        LocationService.sharedInstance.delegate = self
        settingDAO.getData()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        LocationService.sharedInstance.startUpdatingLocation()
        settingDAO.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AlertadePanico(_ sender: Any) {
       let location = LocationService.sharedInstance.currentLocation
        
        if (location != nil){
            latitud = (location?.coordinate.latitude)!
            longitud = (location?.coordinate.longitude)!
        }
        
        
        if(latitud == 0 || longitud == 0 ){
            Utils().alerta(context: self, title: "Error de Ubicacion", mensaje: "No se puede obtener la Ubicacion")
        }else{
            restService.BotondePanico(context: self, latitud: latitud, longitud: longitud, completionHandler: { (response,stringresponse,error) in
                if (error != nil){
                    Utils().alerta(context: self, title: "Error en el servicio", mensaje: error.debugDescription)
                    return
                }
                if(stringresponse != nil){
                    Utils().alerta(context: self, title: "Error", mensaje: stringresponse!)
                   return
                }
                
                if(response?.estatus == 1){
                   Utils().alerta(context: self, title: "Alerta Exitosa", mensaje: "Se envio la alerta correctamente")
                }
                print(response?.estatus ?? "")
            })
        }
    }

    
    func setGradientBackground() {
        let colorTop =  Utils().colorBackground.cgColor
        let colorBottom = Utils().colorDegradado.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.60, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: LocationService Delegate
    func tracingLocation(_ currentLocation: CLLocation) {
        self.latitud = currentLocation.coordinate.latitude
        self.longitud = currentLocation.coordinate.longitude
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        print("tracing Location Error : \(error.description)")
    }
    
   

}
