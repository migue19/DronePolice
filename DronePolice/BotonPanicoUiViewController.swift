//
//  BotonPanicoUiViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 30/05/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import CoreLocation

class BotonPanicoUiViewController: UIViewController,CLLocationManagerDelegate {
    var restService = RestService()
    var settingDAO = SettingsDAO()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation! = nil
    var longitud = 0.0
    var latitud = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startMonitoringSignificantLocationChanges()
        
        // Do any additional setup after loading the view.
        settingDAO.getData()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
        settingDAO.getData()
    }

    func locationAuthStatus(){
        
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AlertadePanico(_ sender: Any) {
        
        restService.BotondePanico(context: self, latitud: latitud, longitud: longitud, completionHandler: { (response, error) in
            if (error != nil){
                print("error: ",error ?? "hay un errror")
                return
            }
            
            print(response ?? "")
        })
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        print("Current location: \(currentLocation)")
        
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        
        longitud = long
        latitud = lat
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                //self.displayLocationInfo(placemark: pm!)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
    /*func displayLocationInfo(placemark: CLPlacemark!) {
        if placemark != nil {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            //print(placemark.addressDictionary ?? "")
            print(placemark.subAdministrativeArea ?? "") //No se que pedo
            print(placemark.subThoroughfare ?? "") //numero
            print(placemark.name ?? "")  //Calle y numero
            print(placemark.thoroughfare ?? "")  //Calle
            print(placemark.subLocality ?? "") //Colonia
            print(placemark.locality ?? "" )   //Puebla
            print(placemark.postalCode ?? "" ) //CP
            print(placemark.administrativeArea ?? "" ) //Abreviatura City
            print(placemark.country ?? "") //Pais
        }
    }*/


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
