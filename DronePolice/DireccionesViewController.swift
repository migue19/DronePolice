//
//  DireccionesViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 07/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit


struct promocion {
    let titulo: String!
    let descripcion: String!
    let fecha: String!
}

class DireccionesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var direcciones = [Direccion]()
    let restService = RestService()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    
        
        restService.ObtenerDirecciones { (response, error) in
            if(error != nil){
            print(error)
                return
            }
            
            self.direcciones = (response?.direccion)!
            
            self.tableView.reloadData()
            
        }
       
        
        
        
        
        // Do any additional setup after loading the view.
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
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //let cell = Bundle.main.loadNibNamed("PromocionesTableViewCell", owner: self, options: nil)?.first as! PromocionesTableViewCell
        let indice = indexPath.row
        
      
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        cell.textLabel?.text = direcciones[indice].calle + " " + direcciones[indice].colonia + " " + direcciones[indice].cp
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
    
    
    
  /*  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hola")
        
        let direccion = direcciones[indexPath.row]
        
        self.performSegue(withIdentifier: "showAgregarDireccion", sender: direccion)
        
    }*/
    
   
    
    
    
    
    
    
    
}


