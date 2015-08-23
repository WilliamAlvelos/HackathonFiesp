//
//  Registro2ViewController.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 22/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class Registro2ViewController: UIViewController, CLLocationManagerDelegate{

    
    @IBOutlet var tags: UITextField!
    var user: User?
    
    var autoIncrement:Int = 0
    
    var locationManager = CLLocationManager()
    
    var base64String: NSString?
    
    var coordenada = CLLocationCoordinate2D()

    @IBOutlet var descricao: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageFirebase()
        self.view.backgroundColor = Colors.Azul
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupImageFirebase(){
            var ref = Firebase(url: String(format: "https://hackathonfiesp.firebaseio.com/Users"))
    
            ref.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) -> Void in
                var int = snapshot.value["id"] as! Int
                int = int + 1
                if(int > self.autoIncrement){
                    self.autoIncrement = int
                }

            })
        
        }
    
    @IBAction func RegisterAction(sender: AnyObject) {
        
        registerUser(self.user!.image, name: self.user!.name, email: self.user!.email, senha: self.user!.senha, descricao: self.descricao.text, id: self.autoIncrement, habilidades: self.tags.text)
        
        
        var usuarioDefault = User(id: self.user!.id, descricao: self.descricao.text, nome: self.user!.name, image: self.user!.image, email: self.user!.email, tags: self.tags.text)
        
        
        UserDAODefault.saveLogin(user!)
        
        var nextView = TransitionManager.creatView("homeNav")
        
        self.presentViewController(nextView, animated: true, completion: nil)
        
    }
    
    func registerUser(image: UIImage!, name:String!, email: String!, senha:String!, descricao:String!, id:Int!, habilidades:String!){
        
        var messagesRef = Firebase(url: String(format: "https://hackathonfiesp.firebaseio.com/Users"))
        
        var uploadImage = image
        
        var imageData: NSData = UIImagePNGRepresentation(uploadImage)
        
        self.base64String = imageData.base64EncodedStringWithOptions(.allZeros)
        
        messagesRef.childByAppendingPath(String(id)).setValue([
            "imageUser": self.base64String!,
            "nome":name,
            "email":email,
            "senha":senha,
            "descricao":descricao,
            "id":id,
            "tags":habilidades,
            "moedas":1
            ])
        
        var messagesRefID = Firebase(url: String(format: "https://hackathonfiesp.firebaseio.com/Users"))
        
        messagesRefID.childByAppendingPath("id").setValue(["id": id])
        
        print(self.coordenada.latitude)
        
    }
    
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            //showActivity()
            
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.AuthorizedAlways:
                shouldIAllow = true
            default:
                //LOCATION IS RESTRICTED ********
                //LOCATION IS RESTRICTED ********
                //LOCATION IS RESTRICTED ********
                return
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
            
            if (shouldIAllow == true) {
                // Start location services
                locationManager.startUpdatingLocation()
            }
            
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        locationManager.stopUpdatingLocation()
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        self.coordenada = coord
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
