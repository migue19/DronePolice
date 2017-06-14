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
    var direcciones = [DireccionResponse]()
    let restService = RestService()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backItem?.title = " "

        self.navigationController?.navigationBar.tintColor = Utils().colorPrincipal
        self.title = "DIRECCIONES"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: Utils().colorPrincipal]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        let Nam1BarBtnVar = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDireccion(_:)))
       
        self.navigationItem.setRightBarButtonItems([Nam1BarBtnVar], animated: true)

    
        
        restService.AgregarDirecciones(context: <#T##UIViewController#>, identificador: <#T##String#>, telefono: <#T##String#>, referencia: <#T##String#>, calle: <#T##String#>, numinterior: <#T##String#>, numexterior: <#T##String#>, colonia: <#T##String#>, ciudad: <#T##String#>, estado: <#T##String#>, cp: <#T##String#>, pais: <#T##String#>, completionHandler: <#T##(GenerarQrResponse?, Error?) -> ()#>)
       
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func addDireccion(_ button: UIButton){
      self.performSegue(withIdentifier: "showAgregarDireccion", sender: self)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


extension DireccionesViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        
        cell.textLabel?.text = direcciones[indice].direccion.calle
        //cell.imagen.image = promociones[indice].image
        //cell.descripcion.text = promociones[indice].descripcion
        //cell.fecha.text = promociones[indice].fecha
        //cell.textLabel?.text = array[indexPath.row]
        
        return cell
    }
    
}


