//
//  CustomButton.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 23/05/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override func awakeFromNib() {
        self.layer.cornerRadius = self.layer.bounds.height/2
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
    }
}
