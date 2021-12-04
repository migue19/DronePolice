//
//  UserResponse.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 23/05/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

class UserResponse{
    var usuarioId = Int()
    var rol_id: String! = String()
    var name: String = String()
    var middlename: String = String()
    var surname: String = String()
    var email: String = String()
    
    
    
    init(usuarioid: Int, rol_id: String, name: String, middlename: String, surname: String, email: String)
    {
      self.usuarioId = usuarioid
      self.rol_id = rol_id
      self.name = name
      self.middlename = middlename
      self.surname = surname
      self.email = email
    
    }
}
