//
//  AgregarDireccionesViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 08/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit

class AgregarDireccionesViewController: UIViewController {
    @IBOutlet weak var identificador: UITextField!
    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var referencia: UITextField!
    @IBOutlet weak var calle: UITextField!
    @IBOutlet weak var numexterior: UITextField!
    @IBOutlet weak var numInterior: UITextField!
    @IBOutlet weak var colonia: UITextField!
    @IBOutlet weak var Ciudad: UITextField!
    @IBOutlet weak var estado: UITextField!
    @IBOutlet weak var cp: UITextField!
    @IBOutlet weak var pais: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        self.navigationController?.navigationBar.tintColor = Utils().colorPrincipal
         self.navigationController?.navigationBar.backItem?.title = " "
        
        
        self.title = "REGISTRO"
    
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: Utils().colorPrincipal]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        
        //self.navigationBar.tintColor = Utils().colorPrincipal
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func registrarDireccion(_ sender: Any) {
        if identificador.text == "" || telefono.text == "" ||  referencia.text == "" || calle.text == "" || numexterior.text == "" || numInterior.text == "" || colonia.text == "" || Ciudad.text == "" || estado.text == "" || cp.text == "" || pais.text == ""{
            Utils().alerta(context: self, title: "Error", mensaje: "Todos los campos son obligatorios")
        return
        }
        
        RestService().AgregarDirecciones(context: self, identificador: identificador.text!, telefono: telefono.text!, referencia: referencia.text!, calle: calle.text!, numinterior: numInterior.text!, numexterior: numexterior.text!, colonia: colonia.text!, ciudad: Ciudad.text!, estado: estado.text!, cp: cp.text!, pais: pais.text!) { (response, error) in
            
            self.dismiss(animated: true, completion: nil)

            
            print("hola")
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
