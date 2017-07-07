//
//  AppDelegate.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 23/05/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,
UNUserNotificationCenterDelegate{

    var window: UIWindow?
    
    static var persistentContainer: NSPersistentContainer = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }()
    
    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //UITabBar.appearance().barTintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
        UITabBar.appearance().tintColor = UIColor.black
        
        
      
        
        
        FIRApp.configure()
        
        registerForPushNotifications(application: application)
        
        /*if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self as? FIRMessagingDelegate
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }*/
        
        //application.registerForRemoteNotifications()
        
       // NotificationCenter.default.addObserver(self,
                                               //selector: #selector(self.tokenRefreshNotification),
                                               //name: .firInstanceIDTokenRefresh,
                                               //object: nil)
        
        /*if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            FIRMessaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()*/
        
        
      
        
        GMSServices.provideAPIKey("AIzaSyA_phjhBV0r7ng3Hnlwyb377Jpn9X831M0");//"AIzaSyA6BUpLFoU6tlMcAsSqhYtw46WEKHnOBAg")
        
        GMSPlacesClient.provideAPIKey("AIzaSyA_phjhBV0r7ng3Hnlwyb377Jpn9X831M0");//"AIzaSyA6BUpLFoU6tlMcAsSqhYtw46WEKHnOBAg")
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //self.connectToFcm()
        
        let context = AppDelegate.viewContext
        do{
            let settings = try context.fetch(Settings.fetchRequest())
            if settings.count > 0 {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let main = storyboard.instantiateViewController(withIdentifier: "TabBar") as! TabBarController
                self.window!.rootViewController = main
            }
        }
        catch{
            print("Error al obtener los Datos de la DB-> AppDelegate ")
        }
 
        return true
    }
    
    
    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else{
                    //Do stuff if unsuccessful...
                }
            })
        }
            
        else{ //If user is not on iOS 10 use the old methods we've been using
            let notificationSettings = UIUserNotificationSettings(
                types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            
        }
        
    }
    
    
    
    
    
    
    /*func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        /*let characterSet = CharacterSet(charactersIn: "<>")
        let deviceTokenString = deviceToken.description.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "");
        print("token device: ", deviceTokenString)*/
        
        let characterSet = CharacterSet( charactersIn: "<>" )
        
        let deviceTokenString2 = NSString(format: "%@", deviceToken as CVarArg) as String
        
        let auxtoken = deviceTokenString2.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "")
        
        print(auxtoken)
        
        let token = FIRInstanceID.instanceID().token()

        
        let deviceTokenString: String = ( deviceToken.description as NSString ).trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "");
        
        RestService().RegisterDevice(token: auxtoken, completionHandler: { (respose, error) in
            print(respose ?? "error")
        })
        
        
        print(deviceTokenString2)
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type: FIRInstanceIDAPNSTokenType.sandbox)
    }*/
    
    
    
    
    /*func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")
        
        connectToFcm()
    }*/
    
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(notification.request.content.userInfo)
        
        let userInfo = notification.request.content.userInfo
        
        let title = userInfo["title"] as! String
        
        //let aps = userInfo["aps"] as! [String: Any]
        //let alerta = aps["alert"] as! [String: Any]
        //let descripcion = alerta["body"] as! String
        
        
        let message = userInfo["message"] as! String
        let alertavecinal =  Utils().convertToDictionary(text: message)
        
        let nombre = alertavecinal?["nombre"] as! String
        let latitud = alertavecinal?["latitud"] as? Double ?? 0.0
        let longitud = alertavecinal?["longitud"] as? Double ?? 0.0
        let tipo = alertavecinal?["tipo"] as! Int!
        var comentario = ""
        var imagen = ""
        
        if(tipo == 2){
            comentario = alertavecinal?["comentario"] as! String
            imagen = alertavecinal?["imagen"] as! String
        }
        
     
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MapaAlertaViewController = storyboard.instantiateViewController(withIdentifier: "MapaAlerta") as! MapaAlertaViewController
        
        vc.latitud = latitud
        vc.longitud = longitud
        vc.Snombre = nombre
        vc.Sdescripcion = title
        vc.comentario = comentario
        vc.imagen = imagen
        
        self.window?.rootViewController = vc
        
        
        
        
        
    
        //Handle the notification
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("notificacion push: ",response.notification.request.content.userInfo)
        
        let userInfo = response.notification.request.content.userInfo
        
        let title = userInfo["title"] as! String
        
        //let aps = userInfo["aps"] as! [String: Any]
        //let alerta = aps["alert"] as! [String: Any]
        //let descripcion = alerta["body"] as! String
        
        
        let message = userInfo["message"] as! String
        let alertavecinal =  Utils().convertToDictionary(text: message)
        
        let nombre = alertavecinal?["nombre"] as! String
        let latitud = alertavecinal?["latitud"] as? Double ?? 0.0
        let longitud = alertavecinal?["longitud"] as? Double ?? 0.0
        let tipo = alertavecinal?["tipo"] as! Int!
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MapaAlertaViewController = storyboard.instantiateViewController(withIdentifier: "MapaAlerta") as! MapaAlertaViewController
        
        vc.latitud = latitud
        vc.longitud = longitud
        vc.Snombre = nombre
        vc.Sdescripcion = title
        vc.tipo = tipo!
        
        self.window?.rootViewController = vc
        //Handle the notification
    }
    
    
    
    
    
    
    /*func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        let d : [String : Any] = remoteMessage.appData["notification"] as! [String : Any]
        print(d)
        let body : String = d["body"] as! String
        print(body)
    }*/
    
    
    /*func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }*/
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,                                                                                                                annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        
        return handled
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DronePolice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

