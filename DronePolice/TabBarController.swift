//
//  TabBarController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 01/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.selectedIndex = 1
        self.selectedIndex = 3
        self.tabBar.tintColor = .red
        self.tabBar.unselectedItemTintColor = .cyan
        
        
        //self.tabBar.isTranslucent = false
        ///self.tabBar.barTintColor = UIColor.red.withAlphaComponent(0.4)
        //self.tabBar.backgroundImage = UIImage()
        //self.tabBar.backgroundImage = UIImage()
        /*let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //view.addSubview(blurEffectView)
        self.tabBar.insertSubview(blurEffectView, at: 0)*/
        
        //context.view.layer.
        
    
        
        //imageWithColor(UIColor.clearColor())
       
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //self.tabBarController?.selectedIndex = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
