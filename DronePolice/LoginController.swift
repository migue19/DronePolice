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
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        LocationService.sharedInstance.delegate = self
        
        
      /*  locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startMonitoringSignificantLocationChanges()*/
        /*NOTA: .startMonitoringSignificantLocationChanges y .distanceFilter trabajan en conjunto:
         1.- La primera da la orden de entrar a la funcion didUpdateLocations siempre que el usuario haya transcurrido un tramo significativo de metros.
         2.- La segunda es la distancia o el tramo en metros que debe recorrer el usuario para activar la primera.
         */
        
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
       // locationAuthStatus()
    }
    
    
    
    /*func locationAuthStatus(){
        
        let estatus = CLLocationManager.authorizationStatus()
        
        if estatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        if estatus == .denied || estatus == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        locationManager.startUpdatingLocation()
        
    }*/
    
    
    @IBAction func AccessUser(_ sender: Any) {
        if usuario.text == "" || contraseña.text == ""
        {
          self.alerta(title: "Error en la Informacion", mensaje: "\nLos campos son obligatorios")
            return
        }
        if(latitud == 0 || longitud == 0 ){
            Utils().alerta(context: self, title: "Error de Ubicacion", mensaje: "No se puede obtener la Ubicacion")
            return
        }
        
            
            
        
        restService.AccessUser(latitud: latitud, longitud: longitud, imei: uuid,usuario: usuario.text!, password: contraseña.text!.md5(), completionHandler: { (response, cadena ,error) in
            if error != nil{
              print("Error en el servicio")
            }
            if cadena != nil{
               self.alerta(title: "Error en Sesion", mensaje: "\n"+cadena!)
              print(cadena ?? "")
                return
            }
            
              print(response ?? "Error en el response")
              self.performSegue(withIdentifier: "hola", sender: self)
    
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
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self){
            (result,error) in
            if error != nil{
                print("Error al loguearse: \(String(describing: error))")
                return
            }
            /*if(result!.token.tokenString! != nil){
             print("\(result?.token.tokenString!)")
             }*/
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id,name,email,first_name,last_name"]).start{
                (connetion,result,error) in
                if error != nil{
                    print("error al obtener los parametros del perfil")
                    return
                }
                
                var userID = ""
                var name = ""
                var firstName = ""
                var lastName = ""
                var email = ""
                var facebookProfileUrl = ""
                
                if let data = result as? [String:Any] {
                    userID = data["id"] as! String
                    name = data["name"] as! String
                    firstName = data["first_name"] as! String
                    lastName = data["last_name"] as! String
                    email = data["email"] as! String
                    facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"
                }
                
                
                let lastNameArr = lastName.characters.split{$0 == " "}.map(String.init)
                // or simply:
                // let fullNameArr = fullName.characters.split{" "}.map(String.init)
                
                
                var paterno = ""
                var materno = ""
                
                if lastNameArr.count > 2{
                   paterno = lastNameArr[0]
                   materno = lastNameArr[1]
                }else{
                   paterno = lastNameArr[0]
                }
                
                
                
                print(paterno)
                print(materno)
                print(userID)
                print(name)
                print(firstName)
                print(lastName)
                print(email)
                print(facebookProfileUrl)
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if(error != nil){
                       print("hubo un error: ", error.debugDescription)
                    return
                    }
                    
                    
                    print("face login firebase")
                }

                
                
                
                
                
                /*self.settingsDAO.insertUserInDB(name: name, firstName: firstName, lastName: lastName, email: email, urlImage: facebookProfileUrl)
                
                let urlimage = URL(string: facebookProfileUrl)
                
                self.downloadImage(url: urlimage!)
                
                self.settingsDAO.getData()
                
                self.performSegue(withIdentifier: "showCiudad", sender: self)*/
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
        let name = user.profile.name ?? ""
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
            print("se agrego a firebase")
        }
        
        print(paterno)
        print(materno)
        print(idgoogle)
        print(name)
        print(firstName)
        print(lastName)
        print(email)
        print(urlimage)
        
        
        if(latitud == 0 || longitud == 0 ){
            Utils().alerta(context: self, title: "Error de Ubicacion", mensaje: "No se puede obtener la Ubicacion")
            return
        }
    
        restService.RegistroRedesSociales(email: email, nombre: firstName, apePaterno: paterno, apeMaterno: materno, numCel: "", idSocial: idgoogle, social: "google", imei: uuid, latitud: latitud, longitud: longitud) { (response, error) in
            
            if(error != nil){
                self.alerta(title: "Error en el Servidor", mensaje: error.debugDescription)
             return
            }
        
            
            
            
            let token = response?.token
            let estatus = response?.estatus
            
          
            
            let tokenfirebase = FIRInstanceID.instanceID().token()
            //FirebaseInstanceId.getInstance().getToken()
            /////servico registro device
           
            RestService().RegisterDevice(latitud: self.latitud, longitud: self.longitud, imei: self.uuid,token: tokenfirebase!, completionHandler: { (respose, error) in
                if(error != nil){
                    self.alerta(title: "Error en el Servidor", mensaje: error.debugDescription)
                    return
                }
                
                self.settingsDAO.insertUserInDB(idUser: idgoogle, token: token!, estatus: estatus!, name: name, firstName: firstName, lastName: lastName, email: email, urlImage: String(describing: urlimage), imei: self.uuid)
                
                self.downloadImage(url: urlimage)
                
                self.settingsDAO.getData()
                
                print(respose ?? "error")
                let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "TabBar") as! TabBarController
                
                self.present(vc, animated: true, completion: nil)
                
            })


            
        }
        
    }
    
    
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        print("Current location: \(currentLocation)")
        
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        
        longitud = long
        latitud = lat
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                self.displayLocationInfo(placemark: pm!)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }*/
 
    
   /* func displayLocationInfo(placemark: CLPlacemark!) {
        if placemark != nil {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            //print(placemark.addressDictionary ?? "")
            print(placemark.subAdministrativeArea ?? "") //No se que pedo
            print(placemark.subThoroughfare ?? "") //numero
            print(placemark.name ?? "")  //Calle y numero
            print(placemark.thoroughfare ?? "")  //Calle
            print(placemark.subLocality ?? "") //Colonia
            print(placemark.locality ?? "" )   //Puebla
            print(placemark.postalCode ?? "" ) //CP
            print(placemark.administrativeArea ?? "" ) //Abreviatura City
            print(placemark.country ?? "") //Pais
        }
    }*/

    // MARK: LocationService Delegate
    func tracingLocation(_ currentLocation: CLLocation) {
        latitud = currentLocation.coordinate.latitude
        longitud = currentLocation.coordinate.longitude

    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        print("tracing Location Error : \(error.description)")
    }

    
    
    
    ///////Utils 
    // MARK: - Descargar Imagen y Guardarla en DB
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func alerta(title: String, mensaje: String ){
        let alert = UIAlertController(title: title, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    


}

