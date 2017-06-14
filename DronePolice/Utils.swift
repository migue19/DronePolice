//
//  Utils.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 02/06/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    let colorPrincipal: UIColor = UIColor.init(red: 45/255.0, green: 69/255.0, blue: 134/255.0, alpha: 1)
    //let colorCellGris:UIColor = UIColor.init(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1)
    let colorCellGris: UIColor = UIColor.white
    
    func FechaActual() -> String{
        
        let fecha = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
        let dateString = dateFormatter.string(from: fecha)
        print(dateString)
        return dateString
    
    }
    
    func alerta(context: UIViewController, title: String, mensaje: String ){
        let alert = UIAlertController(title: title, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        context.present(alert, animated: true, completion: nil)
    }
    
    func showLoading(context: UIViewController){
        let pending = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        
        
        //create an activity indicator
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.activityIndicatorViewStyle = .white
        indicator.color = colorPrincipal
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //add the activity indicator as a subview of the alert controller's view
        pending.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: pending.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 80)
        
        let width:NSLayoutConstraint = NSLayoutConstraint(item: pending.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 80)
        
        pending.view.addConstraint(height)
        pending.view.addConstraint(width)
        
        pending.view.subviews.first?.tintColor = UIColor.red
        
        context.present(pending, animated: true, completion: nil)
        
        pending.view.subviews.first?.tintColor = UIColor.red
    
    }
    
    
    
    func convertImageToBase64(image: UIImage) -> String{
        
        
        
        let auximage = resizeImage(image: image)
        
        let imageData = UIImagePNGRepresentation(auximage)
        
        let base64String = imageData?.base64EncodedString(options: .endLineWithCarriageReturn)
        return base64String!
        
    }
    
    
    
    
    
    
    func resizeImage(image: UIImage) -> UIImage
    {
    var actualHeight = Double(image.size.height);
    var actualWidth = Double(image.size.width);
    let maxHeight = 300.0;
    let maxWidth = 400.0;
    var imgRatio = actualWidth/actualHeight;
    let maxRatio = maxWidth/maxHeight;
        
    let compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
    if(imgRatio < maxRatio)
    {
    //adjust width according to maxHeight
    imgRatio = maxHeight / actualHeight;
    actualWidth = imgRatio * actualWidth;
    actualHeight = maxHeight;
    }
    else if(imgRatio > maxRatio)
    {
    //adjust height according to maxWidth
    imgRatio = maxWidth / actualWidth;
    actualHeight = imgRatio * actualHeight;
    actualWidth = maxWidth;
    }
    else
    {
    actualHeight = maxHeight;
    actualWidth = maxWidth;
    }
    }
    
    
    let rect = CGRect(x: 0.0,y: 0.0,width: CGFloat(actualWidth),height: CGFloat(actualHeight));
    UIGraphicsBeginImageContext(rect.size);
        
    image.draw(in: rect)
        
    let img = UIGraphicsGetImageFromCurrentImageContext();
    let imageData = UIImageJPEGRepresentation(img!, CGFloat(compressionQuality))
        
    UIGraphicsEndImageContext();
        
        
        
    
    return UIImage(data: imageData!)!
    }
    
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
    
}
