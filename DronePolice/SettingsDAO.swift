//
//  SettingsDAO.swift
//  OfferCity
//
//  Created by Miguel Mexicano Herrera on 15/05/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation
import CoreData

class SettingsDAO{
    var settings: [Settings] = []

    
    /////Insert
    
    func InsertSetting(descripcion: String, valor: String){
        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Settings> = Settings.fetchRequest()
        
        request.predicate = NSPredicate(format: "descripcion = %@", descripcion)
        
        do{
            let fetchResult = try context.fetch(request)
            if fetchResult.count > 0{
                print("Updateando Setting")
                UpdateSettingCoreData(setting: fetchResult[0], descripcion: descripcion, valor: valor)
                
            }else{
                print("Insertando Setting")
                let userData = Settings(context: context)
                
                userData.descripcion = descripcion
                userData.valor = valor
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
        catch{
            print("No se pudo hacer la conexion con la DB")
            
        }
    }
    
    
    func InsertImageDB(data: Data){
        let context = AppDelegate.viewContext
        do {
            let fetchRequest = try context.fetch(Imagen.fetchRequest())
            if fetchRequest.count > 0
            {
                print("Updateando Imagen")
                UpdateImage(image: fetchRequest[0] as! Imagen, data: data)
            }
            else{
                print("Insertando Imagen")
                let image = Imagen(context: context)
                
                image.imagen = data as NSData
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }catch{
            print("Error al Obtener imagenes de la DB")
        }
    }
    
    
    
    
   //////Update
    
    func findAndUpdateSettings(descripcion: String, valor: String){
        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Settings> = Settings.fetchRequest()
        
        request.predicate = NSPredicate(format: "descripcion = %@", descripcion)
        
        do{
            let settings2 = try context.fetch(request)
            if settings2.count > 0 {
                for setting in settings2{
                    self.UpdateSettingCoreData(setting: setting, descripcion: descripcion, valor: valor)
                }
            }else{
                print("No Hay Datos Para Updatear")
            }
        }
        catch{
            print("Failed feching")
        }
    }
    
    
    
    func UpdateSettingCoreData(setting: Settings,descripcion: String, valor: String) {
        setting.setValue(descripcion, forKey: "descripcion")
        setting.setValue(valor, forKey: "valor")
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    func UpdateImage(image: Imagen, data: Data){
        image.setValue(data, forKey: "imagen")
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    ///////Delete
    
    func findAndDeleteSettings(descripcion: String) {
        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Settings> = Settings.fetchRequest()
        
        request.predicate = NSPredicate(format: "descripcion = %@", descripcion)
        
        do{
            let settings2 = try context.fetch(request)
            
            if settings2.count > 0 {
                for setting in settings2{
                    deleteSettingCoreData(setting: setting)
                }
            }
            else{
                print("No Hay Datos Para Borrar")
            }
        }
        catch{
            print("Failed feching")
        }
    }
    
    
    func deleteAllSettings(){
        let array = ["Email","Name","FirstName","LastName","ImageURL","id","token","estatus","imei"]
        
        for description in array {
            self.findAndDeleteSettings(descripcion: description)
        }
    }
    
    func deleteSettingCoreData(setting: Settings){
        let context = AppDelegate.viewContext
        
        context.delete(setting)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    
    
    func numberOfImageDB()-> Int{
      let context = AppDelegate.viewContext
        
        do {
        let imagenes = try context.fetch(Imagen.fetchRequest())
            
          return imagenes.count
            
        }catch{
        print("Error al Obtener el numero de imagense en la BD")
        
        }
        
        return 0
    }
    
    
    
    func getDateForDescription(description: String)-> String! {
        
        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Settings> = Settings.fetchRequest()
        
        request.predicate = NSPredicate(format: "descripcion = %@", description)
        
        do{
            let settings2 = try context.fetch(request)
            
            if settings2.count > 0 {
                
                return settings2[0].valor
            }
            else{
                print("No Hay Datos Para Obtener")
                return nil
            }
        }
        catch{
            print("Failed feching")
            return nil
        }
    
    }
    
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            settings = try context.fetch(Settings.fetchRequest())
            
            if settings.count > 0 {
                for setting in settings{
                    print(setting.descripcion ?? "")
                    print(setting.valor ?? "")
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
    
    func insertUserInDB(idUser: String, token: String, estatus: Int, name: String, firstName: String, lastName: String, email: String, urlImage: String,imei: String){
        self.InsertSetting(descripcion: "id", valor: idUser)
        self.InsertSetting(descripcion: "token", valor: token)
        self.InsertSetting(descripcion: "imei", valor: imei)
        self.InsertSetting(descripcion: "estatus", valor: String(estatus))
        self.InsertSetting(descripcion: "Name", valor: name)
        self.InsertSetting(descripcion: "FirstName", valor: firstName)
        self.InsertSetting(descripcion: "LastName", valor: lastName)
        self.InsertSetting(descripcion: "Email", valor: email)
        self.InsertSetting(descripcion: "ImageURL", valor: urlImage)
    }
    
    
    
    
    // MARK: - Eliminar la imagen del Usuario
    func deleteAllImageDB(){
        let context = AppDelegate.viewContext
        do{
            let imagenes: [Imagen] = try context.fetch(Imagen.fetchRequest())
            
            if imagenes.count > 0 {
                for image in imagenes{
                    deleteImageCoreData(image: image)
                }
            }else{
                print("No Hay Datos Para Mostrar")
            }
        }
        catch{
            print("Failed feching")
        }
    
    }
    
    
    
    func deleteImageCoreData(image: Imagen){
        let context = AppDelegate.viewContext
        
        context.delete(image)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    

   



}
