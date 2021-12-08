//
//  PerfilViewController.swift
//  followme
//
//  Created by Miguel Mexicano Herrera on 15/04/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import Firebase

let offset_HeaderStop:CGFloat = 40.0
let offset_B_LabelHeader:CGFloat = 95.0
let distance_W_LabelHeader:CGFloat = 35.0

class PerfilViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var avatarImage:UIImageView!
    @IBOutlet var header:UIView!
    @IBOutlet var headerLabel:UILabel!
    @IBOutlet weak var labelName: UILabel!
    var headerImageView: UIImageView!
    var headerBlurImageView: UIImageView!
    
    
    var imagenes: [Imagen] = []
    let settingsDAO = SettingsDAO()
    
    
    var blurredHeaderImageView:UIImageView?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var options = ["Direcciones","Historial","",""]
    var imageCell = ["iconodirecciones","historial","",""]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        scrollView.delegate = self
        tableView.register(UINib(nibName: ProfileTableViewCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.dataSource = self
        tableView.dataSource = self
        tableView.backgroundColor = Utils().colorCellGris
        self.view.backgroundColor = Utils().colorCellGris
        
        print("El numero de imagens en la db es: ", self.settingsDAO.numberOfImageDB())
        
        
        tableView.tableFooterView = UIView()
        
        let name = settingsDAO.getDateForDescription(description: "Name")
        
        headerLabel.text = name
        labelName.text = name
        
        self.LoadImageProfile()
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        ///appDelegate.shouldRotate = false // or false to disable rotation
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: false)
        // Header - Image
        navigationController?.setNavigationBarHidden(true, animated: false)
        //self.LoadImageProfile()
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.image = UIImage(named: "city")
        headerImageView?.contentMode = UIView.ContentMode.scaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)
        
        // Header - Blurred Image
        
        headerBlurImageView = UIImageView(frame: header.bounds)
        headerBlurImageView?.image = UIImage(named: "city")
        //?.blurredImage(withRadius: 10, iterations: 20, tintColor: UIColor.clear)
        headerBlurImageView?.contentMode = UIView.ContentMode.scaleAspectFill
        headerBlurImageView?.alpha = 0.0
        header.insertSubview(headerBlurImageView, belowSubview: headerLabel)
        
        header.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            header.layer.transform = headerTransform
        }
        
        // SCROLL UP/DOWN ------------
        
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            
            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if avatarImage.layer.zPosition < header.layer.zPosition{
                    header.layer.zPosition = 0
                }
                
            }else {
                if avatarImage.layer.zPosition >= header.layer.zPosition{
                    header.layer.zPosition = 2
                }
            }
        }
        
        // Apply Transformations
        
        header.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform
    }
    
    @IBAction func shamelessActionThatBringsYouToMyTwitterProfile() {
        if UIApplication.shared.canOpenURL(URL(string:"twitter://user?screen_name=bitwaker")!){
            UIApplication.shared.open(URL(string:"twitter://user?screen_name=bitwaker")!)
        }else{
            UIApplication.shared.open(URL(string:"https://twitter.com/bitwaker")!)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    
    
    
    //////Metodos TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return options.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = Utils().colorCellGris
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 45
            
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as? ProfileTableViewCell else {
                return UITableViewCell()
            }
            let image = imageCell[indexPath.row]
            let option = options[indexPath.row]
            cell.setupCell(image: image, description: option)
            return cell
        case 1:
            let cell = UITableViewCell()
            let button : UIButton = UIButton(type:UIButton.ButtonType.custom)
            button.frame = CGRect(origin: CGPoint(x: 40,y :60), size: CGSize(width: cell.bounds.width*0.8, height: cell.bounds.height))
            let cellHeight: CGFloat = 44.0
            button.center = CGPoint(x: view.bounds.width / 2.0, y: cellHeight / 2.0)
            button.layer.cornerRadius = button.bounds.height/2
            button.backgroundColor = Utils().colorPrincipal
            button.setTitle("Cerrar Sesion", for: UIControl.State.normal)
            cell.selectionStyle = .none
            cell.addSubview(button)
            cell.accessoryType = .none;
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0);
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "showDireccion", sender: self)
            case 1:
                self.performSegue(withIdentifier: "showHistorial", sender: self)
            case 2:
                print("Ir a Promociones")
                //self.performSegue(withIdentifier: "showCustom", sender: self)
            case 3:
                print("Ir a Reservaciones")
            case 4:
                print("Ir a Ajustes")
                //self.performSegue(withIdentifier: "showAjustes", sender: self)
            case 5:
                print("Ir a Ayuda")
            default:
                break
            }
        case 1:
            CerrarSession()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    /*func tableView(_ tableView: UITableView,
     willDisplay cell: UITableViewCell,
     forRowAt indexPath: IndexPath) {
     
     let auxView = UIView()
     auxView.backgroundColor = UIColor(red: 100/255.0,
     green: 127/255.0,
     blue: 164/255.0,
     alpha: 0.3)
     
     cell.selectedBackgroundView = auxView
     
     }*/
    @objc func CerrarSession(){
        
        let alertController = UIAlertController(title: "Cerrar sesión", message: "Estas Seguro de Cerrar Sesion", preferredStyle: .alert)
        
        //Cancelar
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelar)
        
        //Cerrar sesion
        let cerrarSesion = UIAlertAction(title: "Cerrar sesión", style: .destructive, handler: { (action: UIAlertAction!) in
            
            //Cerramos persistencia de sesion
            self.settingsDAO.deleteAllImageDB()
            self.settingsDAO.deleteAllSettings()
            
            //Log out Firebase
            try! Auth.auth().signOut()
            //Regresamos al inicio de la aplicacion
            let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "StoryBoardStart")
            UIApplication.shared.windows.first?.rootViewController = loginViewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        })
        alertController.addAction(cerrarSesion)
        
        //Show alert
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    //Core Data
    
    
    func LoadImageProfile(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            imagenes = try context.fetch(Imagen.fetchRequest())
            
            if imagenes.count > 0 {
                for image in imagenes{
                    //print(image.imagen ?? "")
                    avatarImage.image = UIImage(data: image.imagen! as Data)
                    print("")
                }
            }else{
                print("No Hay Datos Para Mostrar")
            }
        }
        catch{
            print("Failed feching")
        }
        
    }
    
    
    
    
    
    
}



