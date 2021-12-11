//
//  EstadosViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 27/07/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit


protocol PopupEstadoProtocolo{
    func muestraEstado(estadoAux: Estado)
}

class EstadosViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var restService = RestService()
    var latitud = 0.0
    var longitud = 0.0
    var popUpVC: PopupEstadoProtocolo!
    var arrayEstados = [Estado]()
    let utils = Utils()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = AppDelegate.viewContext
        do{
            let estados = try context.fetch(Estados.fetchRequest())
            if estados.count > 0 {
               print(estados.count)
                
                let responseData = estados
                for estado in responseData {
                  let auxestado = Estado.init(estadoid: Int(estado.estadoid), nombre: estado.nombre!)
                    
                  arrayEstados.append(auxestado)
                }
                self.tableView.reloadData()
            }
            else{
                print("No hay Estados")
                DescargarEstados()
            }
        }
        catch{
            print("Error al obtener los Datos de la DB-> AppDelegate ")
        }
        
        
        
        
    }
    
    
    func DescargarEstados(){
        restService.GetEstados { (response, stringresponse) in
            if(stringresponse != nil){
                //self.dismiss(animated: true, completion: nil)
                Utils().alerta(context: self, title: "Error", mensaje: stringresponse!)
                return
            }
            self.arrayEstados = (response?.estados)!
            for estado in self.arrayEstados {
                EstadosDAO().InsertEstado(estado: estado)
            }
            EstadosDAO().getData()
            self.tableView.reloadData()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

    
    extension EstadosViewController: UITableViewDelegate{
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerText = UILabel()
            headerText.textColor = UIColor.white
            headerText.backgroundColor = utils.colorPrincipal
            headerText.font = UIFont.boldSystemFont(ofSize: 20)
            headerText.adjustsFontSizeToFitWidth = true
            
            switch section{
            case 0:
                headerText.textAlignment = .center
                headerText.text = "ESTADOS"
                
            default:
                break
            }
            
            return headerText
        }
        
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
             return 50
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "ESTADOS"
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if ( popUpVC != nil) {
                self.popUpVC.muestraEstado(estadoAux: arrayEstados[indexPath.row])
                self.dismiss(animated: true, completion: nil)
                //getAddress(latitud: point.latitude, longitud: point.longitude)
            }else{
                print("no carga protocolo")
            }
            
            //self.performSegue(withIdentifier: "showAgregarDireccion", sender: direccion)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    extension EstadosViewController: UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrayEstados.count
        }
        
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            //let cell = Bundle.main.loadNibNamed("PromocionesTableViewCell", owner: self, options: nil)?.first as! PromocionesTableViewCell
            let indice = indexPath.row
            
            
            cell.textLabel?.numberOfLines = 0;
            cell.textLabel?.lineBreakMode = .byWordWrapping;
            cell.textLabel?.text = arrayEstados[indice].nombre
            //cell.imagen.image = promociones[indice].image
            //cell.descripcion.text = promociones[indice].descripcion
            //cell.fecha.text = promociones[indice].fecha
            //cell.textLabel?.text = array[indexPath.row]
            
            return cell
        }
    }
