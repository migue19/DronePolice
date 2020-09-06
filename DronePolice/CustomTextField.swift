//
//  CustomTextField.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 06/09/20.
//  Copyright © 2020 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation

protocol CustomTextFieldDelegate {
    func pressedToolBarButton()
}

class CustomTextField: UITextField {
    var customDelegate: CustomTextFieldDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        setupView()
    }
    func setupView() {
        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
        UIBarButtonItem(title: "Cancelar", style: .done, target: self, action: #selector(cancelNumberPad)),
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Hecho", style: .done, target: self, action: #selector(doneWithNumberPad))]
        toolbar.sizeToFit()
        toolbar.tintColor = .textButtonColor
        inputAccessoryView = toolbar
        autocorrectionType = .no
    }
    @objc func cancelNumberPad() {
        self.resignFirstResponder()
    }
    @objc func doneWithNumberPad() {
        self.resignFirstResponder()
    }
}
extension CustomTextField: UITextFieldDelegate {
}
