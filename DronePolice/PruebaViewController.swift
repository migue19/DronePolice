//
//  PruebaViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 23/05/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit

class PruebaViewController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var ContainerA: UIView!
    @IBOutlet weak var ContainerB: UIView!
    @IBOutlet weak var ContainerC: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ContainerB.alpha = 0
        self.ContainerC.alpha = 0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showComponent(_ sender: Any) {
        
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.5, animations: {
                self.ContainerA.alpha = 1
                self.ContainerB.alpha = 0
                self.ContainerC.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.5, animations: {
                self.ContainerA.alpha = 0
                self.ContainerB.alpha = 1
                self.ContainerC.alpha = 0
            })
        case 2:
            UIView.animate(withDuration: 0.5, animations: {
                self.ContainerA.alpha = 0
                self.ContainerB.alpha = 0
                self.ContainerC.alpha = 1
            })
        default:
            break
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

}
