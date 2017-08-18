//
//  DireccionTableViewCell.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 16/07/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit

class DireccionTableViewCell: UITableViewCell {
    @IBOutlet weak var direccionTxt: UILabel!
    @IBOutlet weak var eliminarDir: UIButton!
    //let context = DireccionesViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func EliminarDireccion(_ sender: Any) {
        
        
        //let iddirecccion = (sender as! UIButton).tag
        
        /*RestService().ActualizarDireccion(context: context, latitud: 0, longitud: 0, latitudDir: 0, longitudDir: 0, iddireccion: iddirecccion, identificador: "", telefono: "", referencia: "", calle: "", numinterior: "", numexterior: "", colonia: "", ciudad: "", estado: "", cp: "", pais: "", eliminar: true, completionHandler: { (response,stringresponse ,error) in
            
            context.dismiss(animated: true, completion: nil)
            
            if(error != nil){
                Utils().alerta(context: context, title: "Error en el servidor", mensaje: error.debugDescription)
                return
            }
            if(stringresponse != nil){
                Utils().alerta(context: context, title: "Error", mensaje: stringresponse!)
                return
            }
            
            if(response?.estatus == 1){
                Utils().alerta(context: context, title: "Exito", mensaje: "Se Actualizo Correctamente la Direccion")
            }
    })*/
        
    }

}
