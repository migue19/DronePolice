//
//  DireccionesViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 07/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import CoreLocation

struct promocion {
    let titulo: String!
    let descripcion: String!
    let fecha: String!
}

class DireccionesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var direcciones = [Direccion]()
    let restService = RestService()
    var longitud = 0.0
    var latitud = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
       // LocationService.sharedInstance.delegate = self
        LocationService.sharedInstance.startUpdatingLocation()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backItem?.title = " "

        self.navigationController?.navigationBar.tintColor = Utils().colorPrincipal
        self.title = "DIRECCIONES"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: Utils().colorPrincipal]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        let Nam1BarBtnVar = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDireccion(_:)))
       
        self.navigationItem.setRightBarButtonItems([Nam1BarBtnVar], animated: true)
        
        
        let location = LocationService.sharedInstance.currentLocation
        
        if(location != nil){
           longitud = (location?.coordinate.longitude)!
           latitud = (location?.coordinate.latitude)!
        }//else{
         //Utils().alerta(context: self, title: "Error Ubicacion", mensaje: "Error al obtener la ubicacion")
       // }
        
        restService.ObtenerDirecciones(context: self, latitud: latitud, longitud: longitud) { (response,stringresponse ,error) in
            
            //self.dismiss(animated: true, completion: nil)
            
            
            if(error != nil){
                //self.dismiss(animated: true, completion: nil)
                Utils().alerta(context: self, title: "Error en el servidor", mensaje: error.debugDescription)
                
                return
            }
            if(stringresponse != nil){
                //self.dismiss(animated: true, completion: nil)
                Utils().alerta(context: self, title: "Error", mensaje: stringresponse!)
              return
            }
            
            
            self.direcciones = (response?.direccion)!
            
            if(self.direcciones.count == 0){
                //self.dismiss(animated: true, completion: nil)
                let alerta: UIAlertController = UIAlertController(title: "Error", message: "No hay direcciones registradas", preferredStyle: .alert)
                let okAction: UIAlertAction = UIAlertAction(title: "ok", style: .default) { action -> Void in
                    self.performSegue(withIdentifier: "showAgregarDireccion", sender: Direccion())
                }
                alerta.addAction(okAction)
                self.present(alerta, animated: true, completion: nil)
                return
            }
            
            self.tableView.reloadData()
            
            //self.dismiss(animated: true, completion: nil)
            //self.dismiss(animated: true, completion: nil)
        }

        //self.dismiss(animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
    }
  

    
    
    func ActulizarDirecciones(){
        restService.ObtenerDirecciones(context: self, latitud: latitud, longitud: longitud) { (response,stringresponse ,error) in
            
            self.dismiss(animated: true, completion: nil)
            
            if(error != nil){
                Utils().alerta(context: self, title: "Error en el servidor", mensaje: error.debugDescription)
                return
            }
            if(stringresponse != nil){
                Utils().alerta(context: self, title: "Error", mensaje: stringresponse!)
                return
            }
            
            
            self.direcciones = (response?.direccion)!
            
            if(self.direcciones.count == 0){
                let alerta: UIAlertController = UIAlertController(title: "Error", message: "No hay direcciones registradas", preferredStyle: .alert)
                let okAction: UIAlertAction = UIAlertAction(title: "ok", style: .default) { action -> Void in
                    self.performSegue(withIdentifier: "showAgregarDireccion", sender: Direccion())
                }
                alerta.addAction(okAction)
                self.present(alerta, animated: true, completion: nil)
                return
            }
            
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
      }
    }
    
    
    
    func addDireccion(_ button: UIButton){
      self.performSegue(withIdentifier: "showAgregarDireccion", sender: Direccion())
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAgregarDireccion"
        {
            let destino = segue.destination as! AgregarDireccionesViewController
            
            destino.direccion = sender as! Direccion
        
        
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}


extension DireccionesViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hola")
        let direccion = direcciones[indexPath.row]
        
        self.performSegue(withIdentifier: "showAgregarDireccion", sender: direccion)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension DireccionesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return direcciones.count
    }
    

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DireccionTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DireccionTableViewCell
        //let cell = Bundle.main.loadNibNamed("PromocionesTableViewCell", owner: self, options: nil)?.first as! PromocionesTableViewCell
        let indice = indexPath.row
        
        
        
        cell.direccionTxt.numberOfLines = 0;
        cell.direccionTxt.lineBreakMode = .byWordWrapping
        cell.direccionTxt.text = direcciones[indice].calle
        
        cell.eliminarDir.tag = indice
        cell.eliminarDir.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
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
        self.direcciones.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func buttonAction(sender: UIButton!) {
        let indice = sender.tag
        //print("Button tapped: \(iddireccion)")
        
        RestService().ActualizarDireccion(context: self, latitud: latitud, longitud: longitud , latitudDir: latitud, longitudDir: longitud, iddireccion: direcciones[indice].direccionid, identificador: direcciones[indice].identificador, telefono: direcciones[indice].telefono, referencia: direcciones[indice].referencia, calle: direcciones[indice].calle, numinterior: direcciones[indice].noInt, numexterior: direcciones[indice].noExt, colonia: direcciones[indice].colonia, ciudad: direcciones[indice].municipio, estadoId: 0, cp: direcciones[indice].cp, pais: direcciones[indice].pais, eliminar: true, completionHandler: { (response,stringresponse ,error) in
            
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
                self.ActulizarDirecciones()
            }
        })
        
        
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


