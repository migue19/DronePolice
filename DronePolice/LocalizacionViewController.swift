//
//  LocalizacionViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 14/07/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import GoogleMaps


protocol PopupLocalizacionProtocolo{
    func muestraDireccion(calleString: String, numero: String, ciudad: String, codigoPostal: String, estadoString: String, latitudDir: Double, longitudDir: Double)
}

class LocalizacionViewController: UIViewController,GMSMapViewDelegate {
    @IBOutlet weak var closebutton: UIButton!
    @IBOutlet weak var donebutton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    var popUpVC: PopupLocalizacionProtocolo!

    override func viewDidLoad() {
        super.viewDidLoad()
        closebutton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        donebutton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        setupMap()
        //createMarker()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupMap(){
        let camera = GMSCameraPosition.camera(withLatitude: 19.071514, longitude: -98.245873, zoom: 13.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    
    func createMarker(){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 19.071514, longitude: -98.245873)
        marker.title = "Hola"
        marker.snippet = "Como estas"
        marker.map = mapView
    }
    
    
    @IBAction func closeView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getLocalizacion(_ sender: Any) {
        let point = mapView.camera.target
        
        if ( popUpVC != nil) {
            getAddress(latitud: point.latitude, longitud: point.longitude)
            
        }else{
            print("no carga protocolo")
        }
        

        
        print("latitude: \(point.latitude)")
        print("longitud: \(point.longitude)")
        
    }
   
    
    
    
    func getAddress(latitud: Double, longitud: Double){
        let location = CLLocation(latitude: latitud, longitude: longitud) //changed!!!
        print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0]
                
                let ciudad = (pm.locality != nil) ? pm.locality : ""
                let estado = (pm.subAdministrativeArea != nil) ? pm.subAdministrativeArea : ""
                let codigoPostal = (pm.postalCode != nil) ? pm.postalCode : ""
                let abrevEstado = (pm.administrativeArea != nil) ? pm.administrativeArea : ""
                let pais = (pm.country != nil) ? pm.country : ""
                let calle = (pm.thoroughfare != nil) ? pm.thoroughfare : ""
                let numero = (pm.subThoroughfare != nil) ? pm.subThoroughfare : ""
                let colonia = (pm.subLocality != nil) ? pm.subLocality : ""
                
                print("ciudad: \(String(describing: ciudad!))")
                print("codigoPostal: \(String(describing: codigoPostal!))")
                print("abrevEstado: \(String(describing: abrevEstado!))")
                print("pais: \(String(describing: pais!))")
                print("calle: \(String(describing: calle!))")
                print("numero: \(String(describing: numero!))")
                print("colonia: \(colonia!)")
                print("Estado: \(String(describing: estado!))")
                
                self.popUpVC.muestraDireccion(calleString: calle!, numero: numero!, ciudad: ciudad!, codigoPostal: codigoPostal!, estadoString: estado!, latitudDir: location.coordinate.latitude, longitudDir: location.coordinate.longitude)
                self.navigationController?.popViewController(animated: true)
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
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
