//
//  ViewController.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 23/05/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import CryptoSwift
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import CoreLocation
import Firebase

class LoginController: UIViewController,FBSDKLoginButtonDelegate,GIDSignInUIDelegate,GIDSignInDelegate,LocationServiceDelegate{//, CLLocationManagerDelegate{
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var contraseña: UITextField!
    @IBOutlet weak var fbButton: CustomButton!
    @IBOutlet weak var googButton: CustomButton!
    //let locationManager = CLLocationManager()
    //var currentLocation: CLLocation! = nil
    var longitud = 0.0
    var latitud = 0.0
    let restService = RestService()
    let settingsDAO = SettingsDAO()
    let uuid = UUID().uuidString
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
       
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        LocationService.sharedInstance.delegate = self
        self.setGradientBackground()
        self.setupViewResizerOnKeyboardShown()
        settingsDAO.getData()
        let sizetext = (fbButton.titleLabel?.bounds.size.width)!
        
        let sizeButton = fbButton.bounds.size.width / 2 - sizetext
        
        fbButton.titleEdgeInsets = UIEdgeInsetsMake(
            0.0,sizeButton - 90, 0.0, 0)
        
        
        let sizetextg = (googButton.titleLabel?.bounds.size.width)!
        
        let sizeButtong = googButton.bounds.size.width / 2 - sizetextg
        
        googButton.titleEdgeInsets = UIEdgeInsetsMake(
            0.0,sizeButtong - 90, 0.0, 0)

        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LocationService.sharedInstance.startUpdatingLocation()
    }

    @IBAction func AccessUser(_ sender: Any) {
        if usuario.text == "" || contraseña.text == ""
        {
          Utils().alerta(context: self,title: "Error en la Informacion", mensaje: "\nLos campos son obligatorios")
            return
        }
       /* if(latitud == 0 || longitud == 0 ){
            Utils().alerta(context: self, title: "Error de Ubicacion", mensaje: "No se puede obtener la Ubicacion")
            return
        }*/
 
        restService.AccessUser(latitud: latitud, longitud: longitud, imei: uuid,usuario: usuario.text!, password: contraseña.text!.md5(), completionHandler: { (response, stringresponse ,error) in
            if error != nil{
              Utils().alerta(context: self, title: "Errror en el server", mensaje: error.debugDescription)
              return
            }
            if(stringresponse != nil){
              Utils().alerta(context: self, title: "Error", mensaje: stringresponse!)
                return
            }
            
            
            
            let token = response?.token
            let estatus = response?.estatus
            let nombreCompleto = response?.nombre
            
            let nombreCompletoArr = nombreCompleto?.characters.split{$0 == " "}.map(String.init)
            // or simply:
            // let fullNameArr = fullName.characters.split{" "}.map(String.init)
            var nombre = ""
            var paterno = ""
            var materno = ""
            
            
            if(nombreCompletoArr?.count == 3){
                nombre = (nombreCompletoArr?[0])!
                paterno = (nombreCompletoArr?[1])!
                materno = (nombreCompletoArr?[2])!
            }
            
            if nombreCompletoArr?.count == 2{
                nombre = (nombreCompletoArr?[0])!
                paterno = (nombreCompletoArr?[1])!
            }
            
            if(nombreCompletoArr?.count == 1){
                nombre = (nombreCompletoArr?[0])!
            }
            
            let urlimage = ""
            
            /*FIRAuth.auth()?.createUser(withEmail: self.usuario.text!, password: self.contraseña.text!) { (user, error) in
                
                if(error != nil){
                    Utils().alerta(context: self, title: "Error Firebase", mensaje: error.debugDescription)
                    return
                }
                
            }*/

         
            
            FIRAuth.auth()?.signIn(withEmail: self.usuario.text!, password: self.contraseña.text!) { (user, error) in
                if(error != nil){
                    Utils().alerta(context: self, title: "Error Firebase", mensaje: error.debugDescription)
                   return
                }
                
                let tokenfirebase = FIRInstanceID.instanceID().token()
                
                
                self.settingsDAO.insertUserInDB(idUser: self.usuario.text!, token: token!, estatus: estatus!, name: nombre, apePaterno: paterno, apeMaterno: materno, email: self.usuario.text!, urlImage: urlimage, imei: self.uuid)
                
                //Utils().downloadImage(url: urlimage)
                
                RestService().RegisterDevice(latitud: self.latitud, longitud: self.longitud, imei: self.uuid,token: tokenfirebase!, completionHandler: { (respose, error) in
                    if(error != nil){
                        Utils().alerta(context: self,title: "Error en el Servidor", mensaje: error.debugDescription)
                        self.settingsDAO.deleteAllSettings()
                        self.settingsDAO.getData()
                        return
                    }
                    self.settingsDAO.getData()
                    
                    print(respose ?? "error")
                    let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "TabBar") as! TabBarController
                    
                    self.present(vc, animated: true, completion: nil)
                })


            }
            
        })
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Login Facebook
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Salio de Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Logueado Correctamente Con Facebook")
    }
    
    @IBAction func CustomLoginFB(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["read_stream","email", "public_profile"], from: self){
            (result,error) in
            if error != nil{
                print("Error al loguearse: \(String(describing: error))")
                return
            }
        
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id,name,email,first_name,last_name"]).start{
                (connetion,result,error) in
                if error != nil{
                    print("error al obtener los parametros del perfil")
                    return
                }
                var faceid = ""
                //var name = ""
                var firstName = ""
                var lastName = ""
                var email = ""
                var facebookProfileUrl = ""
                
                if let data = result as? [String:Any] {
                    faceid = data["id"] as! String
                    //name = data["name"] as! String
                    firstName = data["first_name"] as! String
                    lastName = data["last_name"] as! String
                    email = data["email"] as! String
                    facebookProfileUrl = "http://graph.facebook.com/\(faceid)/picture?type=large"
                }
                
                let lastNameArr = lastName.characters.split{$0 == " "}.map(String.init)
                var paterno = ""
                var materno = ""
                
                if lastNameArr.count > 2{
                   paterno = lastNameArr[0]
                   materno = lastNameArr[1]
                }else{
                   paterno = lastNameArr[0]
                }
                
                let tokenface = FBSDKAccessToken.current().tokenString
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: tokenface!)
                
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if(error != nil){
                        
                        Utils().alerta(context: self, title: "Error", mensaje: "Error con logueo firebase: \(error.debugDescription)")
                        return
                    }
                    /*if(self.latitud == 0 || self.longitud == 0 ){
                        Utils().alerta(context: self, title: "Error de Ubicacion", mensaje: "No se puede obtener la Ubicacion")
                        return
                    }*/
                    
                    
                    let urlimage = URL(string: facebookProfileUrl)
                    
                    self.registerWithSocialNetwork(email: email, nombre: firstName, paterno: paterno, materno: materno, idSocial: faceid, social: "facebook", imei: self.uuid, latitud: self.latitud, longitud: self.longitud, urlimage: urlimage!)
                    
                    
                    print("se agrego a firebase")
                }
            }
        }
    }
    
    // MARK: - Login Google
    
    @IBAction func CustomGoogleSingIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print("Error al Loggearse con google: \(error)")
            return
        }
        
        print("Logueo Google Correcto", user)
        
        let idgoogle = user.userID ?? ""
        //let name = user.profile.name ?? ""
        let firstName = user.profile.givenName ?? ""
        let lastName = user.profile.familyName ?? ""
        let email = user.profile.email ?? ""
        let urlimage = user.profile.imageURL(withDimension: 400)!
        
        let lastNameArr = lastName.characters.split{$0 == " "}.map(String.init)
        // or simply:
        // let fullNameArr = fullName.characters.split{" "}.map(String.init)
        
        var paterno = ""
        var materno = ""
        
        if lastNameArr.count >= 2{
            paterno = lastNameArr[0]
            materno = lastNameArr[1]
        }else{
            paterno = lastNameArr[0]
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                          accessToken: (authentication?.accessToken)!)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if(error != nil){
            Utils().alerta(context: self, title: "Error", mensaje: "Error con logueo firebase: \(error.debugDescription)")
                return
            }
            print("se agrego a firebase")
            
            /*if(self.latitud == 0 || self.longitud == 0 ){
                Utils().alerta(context: self, title: "Error de Ubicacion", mensaje: "No se puede obtener la Ubicacion")
                return
            }*/
            
            self.registerWithSocialNetwork(email: email, nombre: firstName, paterno: paterno, materno: materno, idSocial: idgoogle, social: "google", imei: self.uuid, latitud: self.latitud, longitud: self.longitud, urlimage: urlimage)
            
        }
        
        
        
    }
    
    
    
    // MARK: Registro con Redes Sociales
    func registerWithSocialNetwork(email: String, nombre: String, paterno: String, materno: String,idSocial: String, social: String, imei: String,latitud: Double, longitud: Double,urlimage: URL){
        
        restService.RegistroRedesSociales(email: email, nombre: nombre, apePaterno: paterno, apeMaterno: materno, numCel: "", idSocial: idSocial, social: social, imei: uuid, latitud: latitud, longitud: longitud) { (response, error) in
            
            if(error != nil){
                Utils().alerta(context: self,title: "Error en el Servidor", mensaje: error.debugDescription)
                return
            }
            
            let token = response?.token
            let estatus = response?.estatus
            
            let tokenfirebase = FIRInstanceID.instanceID().token()
            
            
            self.settingsDAO.insertUserInDB(idUser: idSocial, token: token!, estatus: estatus!, name: nombre, apePaterno: paterno, apeMaterno: materno, email: email, urlImage: String(describing: urlimage), imei: self.uuid)
            
            Utils().downloadImage(url: urlimage)
            
            RestService().RegisterDevice(latitud: self.latitud, longitud: self.longitud, imei: self.uuid,token: tokenfirebase!, completionHandler: { (respose, error) in
                if(error != nil){
                    Utils().alerta(context: self,title: "Error en el Servidor", mensaje: error.debugDescription)
                    self.settingsDAO.deleteAllSettings()
                    self.settingsDAO.getData()
                    return
                }
                self.settingsDAO.getData()
                
                print(respose ?? "error")
                let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "TabBar") as! TabBarController
                
                self.present(vc, animated: true, completion: nil)
            })
        }
    }
    
    
    func setGradientBackground() {
        let colorTop =  Utils().colorBackground.cgColor
        let colorBottom = Utils().colorDegradado.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.60, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: LocationService Delegate
    func tracingLocation(_ currentLocation: CLLocation) {
        latitud = currentLocation.coordinate.latitude
        longitud = currentLocation.coordinate.longitude

    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        print("tracing Location Error : \(error.description)")
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
   
   // MARK: keyboard autoresizing
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowForResizing),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideForResizing),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    
    
    func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    
    func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }

    


}

