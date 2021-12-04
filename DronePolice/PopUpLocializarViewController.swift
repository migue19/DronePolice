//
//  PopUpLocializarViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 27/07/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import GoogleMaps

protocol PopupUbicacionProtocolo{
    func muestraUbicacion(latitudDir: Double, longitudDir: Double)
}

class PopUpLocializarViewController: UIViewController,GMSMapViewDelegate  {
    @IBOutlet weak var closebutton: UIButton!
    @IBOutlet weak var donebutton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    var popUpVC: PopupUbicacionProtocolo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()

        // Do any additional setup after loading the view.
    }

    private func setupMap(){
        let camera = GMSCameraPosition.camera(withLatitude: 19.071514, longitude: -98.245873, zoom: 13.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getLocalizacion(_ sender: Any) {
        let point = mapView.camera.target
        
        if ( popUpVC != nil) {
            self.popUpVC.muestraUbicacion(latitudDir: point.latitude, longitudDir: point.longitude)
            self.dismiss(animated: true, completion: nil)
            //getAddress(latitud: point.latitude, longitud: point.longitude)
        }else{
            print("no carga protocolo")
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
