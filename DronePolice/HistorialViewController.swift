//
//  HistorialViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano on 10/11/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit

class HistorialViewController: UIViewController {
    @IBOutlet weak var inicioTxt: UITextField!
    @IBOutlet weak var finTxt: UITextField!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataPicker = UIDatePicker()
        dataPicker.datePickerMode = UIDatePickerMode.date
        
        self.finTxt.inputView = dataPicker
        
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: 320, height: 44))
        toolbar.tintColor = UIColor.red
        
        
        
        let doneBtn = UIBarButtonItem.init(title: "Ok", style: .plain, target: self, action: #selector(getDate(datePicker:)))
        
        let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([space,doneBtn], animated: false)
        
        self.finTxt.inputAccessoryView = toolbar
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backItem?.title = " "
        
        self.navigationController?.navigationBar.tintColor = Utils().colorPrincipal
        self.title = "HISTORIAL"
        
        
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: UIControlEvents.valueChanged)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func datePickerChanged(datePicker:UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: datePicker.date)
        inicioTxt.text = strDate
    }
    
    
    @objc func getDate(datePicker:UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: datePicker.date)
        
        print(strDate)
        self.finTxt.text = strDate
    }
    
    
    
    func showActionSheet(){
        let alertController = UIAlertController(title: "Action Sheet", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        
        let  deleteButton = UIAlertAction(title: "Delete forever", style: .destructive, handler: { (action) -> Void in
            print("Delete button tapped")
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func showDataPicker(_ sender: Any) {
        self.showActionSheet()
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

