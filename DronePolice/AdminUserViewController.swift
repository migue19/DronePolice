//
//  AdminUserViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 03/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import CoreLocation

class AdminUserViewController: UIViewController {
    var miembros = [Miembro]()
    var longitud = 0.0
    var latitud = 0.0
    var segment = 1
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMiembrosFamiliares()
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        print(segment)
    }
    
    
    
    
    
    func getMiembrosFamiliares(){
        let location = LocationService.sharedInstance.currentLocation
        
        if (location != nil){
            latitud = (location?.coordinate.latitude)!
            longitud = (location?.coordinate.longitude)!
        }
        
        RestService().ObtenerMiembrosFamiliares(latitud: latitud, longitud: longitud) { (response, stringresponse, error) in
            if(error != nil){
                Utils().alerta(context: self, title: "Error en el servidor", mensaje: error.debugDescription)
                return
            }
            if(stringresponse != nil){
                Utils().alerta(context: self, title: "Error", mensaje: stringresponse!)
                return
            }
            
            
            self.miembros = (response?.miembros)!
            
            if(self.miembros.count == 0){
                self.tableView.reloadData()
                let alerta: UIAlertController = UIAlertController(title: "Error", message: "No hay miembros registrados", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
                
                alerta.addAction(okAction)
                self.present(alerta, animated: true, completion: nil)
                return
            }
            
            self.tableView.reloadData()
            
        }
    
    }
    
    
    func getMiembrosVecinos(){
        let location = LocationService.sharedInstance.currentLocation
        
        if (location != nil){
            latitud = (location?.coordinate.latitude)!
            longitud = (location?.coordinate.longitude)!
        }
        
        RestService().ObtenerMiembrosVecinos(latitud: latitud, longitud: longitud) { (response, stringresponse, error) in
            if(error != nil){
                Utils().alerta(context: self, title: "Error en el servidor", mensaje: error.debugDescription)
                return
            }
            if(stringresponse != nil){
                Utils().alerta(context: self, title: "Error", mensaje: stringresponse!)
                return
            }
            
            
            self.miembros = (response?.miembros)!
            
            if(self.miembros.count == 0){
                self.tableView.reloadData()
                let alerta: UIAlertController = UIAlertController(title: "Error", message: "No hay miembros registrados", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
                
                alerta.addAction(okAction)
                self.present(alerta, animated: true, completion: nil)
                return
            }
            
            self.tableView.reloadData()
            
        }
    
    }
    
    
    
    @IBAction func GetMiembros(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            segment = 1
            getMiembrosFamiliares()
            print("Vecinos")
        case 1:
            segment = 2
            getMiembrosVecinos()
            print("Familiares")
        default:
            break
        }

    }
    
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "agregarMiembro"){
            let vc = segue.destination as! EscanerController
            vc.segment = segment
        }
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
        let idmiembro = miembros[indexPath.row].id
        print(idmiembro)
        //self.performSegue(withIdentifier: "showAgregarDireccion", sender: direccion)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension AdminUserViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return miembros.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //let cell = Bundle.main.loadNibNamed("PromocionesTableViewCell", owner: self, options: nil)?.first as! PromocionesTableViewCell
        let indice = indexPath.row
        
        
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        cell.textLabel?.text = miembros[indice].nombre
        //cell.imagen.image = promociones[indice].image
        //cell.descripcion.text = promociones[indice].descripcion
        //cell.fecha.text = promociones[indice].fecha
        //cell.textLabel?.text = array[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let idmiembro = miembros[indexPath.row].id
        self.miembros.remove(at: indexPath.row)
        
        RestService().eliminarMiembro(latitud: latitud, longitud: longitud, id: idmiembro) { (response, stringresponse, error) in
            if(error != nil){
                Utils().alerta(context: self, title: "Error en el servidor", mensaje: error.debugDescription)
                return
            }
            if(stringresponse != nil){
                Utils().alerta(context: self, title: "Error", mensaje: stringresponse!)
                return
            }
            
            if(response?.estatus == 1){
                Utils().alerta(context: self, title: "Exito", mensaje: "Se elimino correctamente al usuario")
                if(self.segment == 1){
                   self.getMiembrosFamiliares()
                }else{
                   self.getMiembrosVecinos()
                }
            }
        }

        
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


