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
    var settingsDAO = SettingsDAO()
    
    let colorPrincipal: UIColor = UIColor.init(red: 45/255.0, green: 69/255.0, blue: 134/255.0, alpha: 1)
    let colorBackground: UIColor = UIColor.init(red: 41/255.0, green: 52/255.0, blue: 89/255.0, alpha: 1)
    let colorDegradado: UIColor = UIColor.init(red: 86/255.0, green: 102/255.0, blue: 148/255.0, alpha: 1)
    
    let colorCellGris: UIColor = UIColor.white
    
    func currentDate() -> String{
        let fecha = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
        let dateString = dateFormatter.string(from: fecha)
        print(dateString)
        return dateString
    }
    
    func alerta(context: UIViewController, title: String, mensaje: String ){
        let alert = UIAlertController(title: title, message: mensaje, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        context.present(alert, animated: true, completion: nil)
    }
    
    
    func alertaCloseViewMain(context: UIViewController, title: String, mensaje: String ){
        let alert = UIAlertController(title: title, message: mensaje, preferredStyle: UIAlertController.Style.alert)
        //alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:))
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (response) in
            context.dismiss(animated: true, completion: nil)
        }))
        context.present(alert, animated: true, completion: nil)
    }
    
    
    func showLoading(context: UIViewController){
        let pending = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        //create an activity indicator
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.style = .medium
        indicator.color = colorPrincipal
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //add the activity indicator as a subview of the alert controller's view
        pending.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: pending.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
        
        let width:NSLayoutConstraint = NSLayoutConstraint(item: pending.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
        
        pending.view.addConstraint(height)
        pending.view.addConstraint(width)
        
        pending.view.subviews.first?.tintColor = UIColor.red
        
        context.present(pending, animated: true, completion: nil)
        
        pending.view.subviews.first?.tintColor = UIColor.red
    
    }
    
    
    
    func convertImageToBase64(image: UIImage) -> String{
        let auximage = resizeImage(image: image)
        let imageData = auximage.pngData()
        let base64String = imageData?.base64EncodedString(options: .endLineWithCarriageReturn)
        return base64String!
    }
    
    
    func setGradientBackground(context: UIViewController) {
        let colorTop =  Utils().colorBackground.cgColor
        let colorBottom = Utils().colorDegradado.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.60, 1.0]
        gradientLayer.frame = context.view.bounds
        context.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    static func decode<T: Codable>(_ type: T.Type, from data: Data, serviceName: String) -> T? {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print("DecodingError in \(serviceName) - Context:", context.codingPath)
        } catch let DecodingError.keyNotFound(key, context) {
            print("DecodingError in \(serviceName) - Key '\(key)' not found:", context.debugDescription)
            print("DecodingError in \(serviceName) - CodingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("DecodingError in \(serviceName) - Value '\(value)' not found:", context.debugDescription)
            print("DecodingError in \(serviceName) - CodingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context) {
            print("DecodingError in \(serviceName) - Type '\(type)' mismatch:", context.debugDescription)
            print("DecodingError in \(serviceName) - CodingPath:", context.codingPath)
        } catch {
            print("DecodingError in \(serviceName) - Error: ", error)
        }
        return nil
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
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        
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
    
    
    ///////Utils
    // MARK: - Descargar Imagen y Guardarla en DB
    
    
    func downloadImageURL(url: URL, completionHandler: @escaping (Data?) -> ()){
        print("Download Started")
        
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            completionHandler(data)
            print("Download Finished")
        }
    }
    
    
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            
            self.settingsDAO.InsertImageDB(data: data)
            print("Download Finished")
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
}
