//
//  Registro2ViewController.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 22/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import UIKit
import Firebase

class Registro2ViewController: UIViewController {

    
    var user = User()
    
    var base64String: NSString?

    @IBOutlet var descricao: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func RegisterAction(sender: AnyObject) {
        
        registerUser(self.user.image, name: self.user.name, email: self.user.email, senha: self.user.senha, descricao: self.descricao.text)
        
        //https://fiesp.firebaseio.com/
        
    }
    
    func registerUser(image: UIImage!, name:String!, email: String!, senha:String!, descricao:String!){
        
        var messagesRef = Firebase(url: String(format: "https://hackathonfiesp.firebaseio.com/Users"))
        
        var uploadImage = image
        
        var imageData: NSData = UIImagePNGRepresentation(uploadImage)
        
        self.base64String = imageData.base64EncodedStringWithOptions(.allZeros)
        
        messagesRef.childByAutoId().setValue([
            "imageUser": self.base64String!,
            "nome":name,
            "email":email,
            "senha":senha,
            "descricao":descricao
            ])
        
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
