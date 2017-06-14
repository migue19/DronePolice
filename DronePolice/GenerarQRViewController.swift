//
//  GenerarQRViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 02/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit

class GenerarQRViewController: UIViewController {
    @IBOutlet weak var codigoQR: UIImageView!
    let restService = RestService()

    override func viewDidLoad() {
        super.viewDidLoad()

       //self.generateQRCode()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.generateQRCode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func generateQRCode() {
        
        restService.GenerateQR(context: self) { (response, error) in
            if error != nil{
             print("errror",error ?? "error")
                
             self.dismiss(animated: true, completion: nil)
                
                
                
             Utils().alerta(context: self, title: "Error en el Servidor", mensaje: "Hubo un error al consultar el servicio")
                
             self.codigoQR.image = nil
             return
            }
            
            self.dismiss(animated: true, completion: nil)
            
            let qr = response?.qr
            
            let data = qr?.data(using: String.Encoding.ascii)
            
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 3, y: 3)
                
                if let output = filter.outputImage?.applying(transform) {
                    self.codigoQR.image = UIImage(ciImage: output)
                }
            }


        }
    }
}
