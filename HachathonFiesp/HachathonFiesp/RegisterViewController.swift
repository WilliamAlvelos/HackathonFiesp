//
//  RegisterViewController.swift
//  
//
//  Created by William Alvelos on 22/08/15.
//
//

import UIKit
import Firebase


class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var user: User?
    
    var pickerLibrary : UIImagePickerController?
    
    var base64String: NSString?
    
    @IBOutlet var descricao: UITextView!
    @IBOutlet var image: UIButton!
    @IBOutlet var senhaConfirmacao: UITextField!
    @IBOutlet var senhaTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nomeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.image.layer.masksToBounds = true
        self.image.layer.borderWidth = CGFloat(2)
        self.image.layer.borderColor = Colors.Rosa.CGColor
        self.image.layer.cornerRadius = self.image.frame.height/2
        
        pickerLibrary = UIImagePickerController()
        pickerLibrary!.delegate = self
        
        
        if user == nil {
            user = User()
        }
        else {
            self.preloadUser()
        }
        
        // Do any additional setup after loading the view.
    }
    
    private func preloadUser(){
        self.nomeTextField.text = user?.name
        self.emailTextField.text = user?.email
        self.image.setBackgroundImage(user?.image, forState: UIControlState.Normal)
        if(user?.image == nil){
            self.image.setTitle("Tire Foto", forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        PermissionsResponse.checkCameraPermission()
        PermissionsResponse.checkRollCameraPermission()
        
    }
    
    @IBAction func changeImage(sender: AnyObject) {
        
        self.changeImage()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    
    @IBAction func actionAvancar(sender: AnyObject) {
        var user = User(name: self.nomeTextField.text, email: self.emailTextField.text, image: self.image.backgroundImageForState(.Normal)!, senha: self.senhaTextField.text)
        
        var view = TransitionManager.creatView("registro2") as! Registro2ViewController
        view.user = user
        
        
        
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func changeImage(){
        
        var actionsheet: UIAlertController = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default,handler: { (alert: UIAlertAction!) -> Void in
            
            self.pickerLibrary?.sourceType = .Camera
            self.pickerLibrary?.allowsEditing = true
            self.presentViewController(self.pickerLibrary!, animated: true, completion: nil)
        })
        
        let roloCamera = UIAlertAction(title: "Rolo de camera", style: .Default,handler: { (alert: UIAlertAction!) -> Void in
            self.pickerLibrary?.sourceType = .PhotoLibrary
            self.pickerLibrary?.allowsEditing = true
            self.presentViewController(self.pickerLibrary!, animated: true, completion: nil)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel,handler:{ (alert: UIAlertAction!) -> Void in
            println("cancelar")
        })
        
        actionsheet.addAction(cameraAction)
        actionsheet.addAction(roloCamera)
        actionsheet.addAction(cancelAction)
        
        
        self.presentViewController(actionsheet, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        let data : NSData = NSData(data: UIImageJPEGRepresentation(image, 1))
        data.writeToFile(self.imagePathURL().path!, atomically: true)
        
        self.image.setBackgroundImage(image, forState: .Normal)
        
        //user?.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    private func imagePathURL()->NSURL{
        return NSURL.fileURLWithPath(NSString(format: "%@%@", aplicationDocumentsDirectory(),"/userPhoto.JPG") as String)!
    }
    
    private func aplicationDocumentsDirectory()->NSString{
        var paths :NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return paths[0] as! NSString
    }

    
    
    

     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         //Get the new view controller using segue.destinationViewController.
//         //Pass the selected object to the new view controller.
//
//        
//    }

}
