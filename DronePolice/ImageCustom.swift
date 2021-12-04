//
//  ImageCustom.swift
//  DronePolice
//
//  Created by Miguel Mexicano on 09/11/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit

class ImageCustom: UIImageView {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.layer.bounds.height/4
    }
    
}
