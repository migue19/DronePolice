//
//  SiguemeButton.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 26/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit

class SiguemeButton: UIButton {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.layer.bounds.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
