//
//  AdminUserViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 03/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit

class AdminUserViewController: UIViewController {
    var direccciones = ["migue","estas","como","hola"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func EscanearCodigo(_ sender: Any) {
    }

}



extension AdminUserViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 60
     }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hola")
        let direccion = direccciones[indexPath.row]
        
        print(direccion)
        //self.performSegue(withIdentifier: "showAgregarDireccion", sender: direccion)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension AdminUserViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return direccciones.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //let cell = Bundle.main.loadNibNamed("PromocionesTableViewCell", owner: self, options: nil)?.first as! PromocionesTableViewCell
        let indice = indexPath.row
        
        
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        cell.textLabel?.text = direccciones[indice]
        //cell.imagen.image = promociones[indice].image
        //cell.descripcion.text = promociones[indice].descripcion
        //cell.fecha.text = promociones[indice].fecha
        //cell.textLabel?.text = array[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.direccciones.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    
    
    /*  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     print("hola")
     
     let direccion = direcciones[indexPath.row]
     
     self.performSegue(withIdentifier: "showAgregarDireccion", sender: direccion)
     
     }*/
    
    // MARK: LocationService Delegate
    /*func tracingLocation(_ currentLocation: CLLocation) {
     latitud = currentLocation.coordinate.latitude
     longitud = currentLocation.coordinate.longitude
     
     LocationService.sharedInstance.stopUpdatingLocation()
     
     restService.ObtenerDirecciones(latitud: latitud, longitud: longitud) { (response, error) in
     if(error != nil){
     print(error ?? "")
     return
     }
     self.direcciones = (response?.direccion)!
     self.tableView.reloadData()
     }
     
     }
     
     func tracingLocationDidFailWithError(_ error: NSError) {
     print("tracing Location Error : \(error.description)")
     }*/
    
    
    
    
    
    
    
    
    
    
}


