//
//  MapaAlertaViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 13/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import GoogleMaps

class MapaAlertaViewController: UIViewController,GMSMapViewDelegate{
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var Nombre: UILabel!
    @IBOutlet weak var Descripcion: UILabel!
    @IBOutlet weak var sospechoso: CustomButton!
    
    var latitud = Double()
    var longitud = Double()
    var Snombre = String()
    var Sdescripcion = String()
    var comentario = String()
    var imagen = String()
    var titulo = String()
    var tipo = Int()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Nombre.text = Snombre
        Descripcion.text = Sdescripcion
        
        if(tipo == 2){
          sospechoso.isHidden = false
        }
        
        setupMap()
        createMarker()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupMap(){
        let camera = GMSCameraPosition.camera(withLatitude: 19.071514, longitude: -98.245873, zoom: 10.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    
    func createMarker(){
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
      marker.title = titulo
        if (tipo == 2 ){
            marker.snippet = comentario
        }else{
            marker.snippet = Sdescripcion
        }
      
        
    marker.map = mapView
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
