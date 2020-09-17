//
//  EstadosDAO.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 27/07/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import CoreData


class EstadosDAO{
    var estados: [Estados] = []
    
    func InsertEstado(estado: Estado){
        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Estados> = Estados.fetchRequest()
        
        request.predicate = NSPredicate(format: "estadoid == %i", estado.estadoid)
        
        do{
            let fetchResult = try context.fetch(request)
            if fetchResult.count > 0{
                print("Updateando Setting")
                UpdateEstadosCoreData(estado: fetchResult[0], idestado: estado.estadoid, nombre: estado.nombre)
            }else{
                print("Insertando Setting")
                let estadoData = Estados(context: context)
                estadoData.estadoid = Int32(estado.estadoid)
                estadoData.nombre = estado.nombre
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
        catch{
            print("No se pudo hacer la conexion con la DB")
            
        }
    }
    
    
    func UpdateEstadosCoreData(estado: Estados,idestado: Int, nombre: String) {
        estado.setValue(idestado, forKey: "estadoid")
        estado.setValue(nombre, forKey: "nombre")
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            estados = try context.fetch(Estados.fetchRequest())
            
            if estados.count > 0 {
                for estado in estados{
                    print(estado.estadoid )
                    print(estado.nombre ?? "")
                    print("")
                }
            }else{
                print("No Hay Datos Para Mostrar")
            }
        }
        catch{
            print("Failed feching")
        }
        
    }
    
    //func UpdateEstadoCoreData()
    


}
