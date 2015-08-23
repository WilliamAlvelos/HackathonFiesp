//
//  ProfileViewController.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 22/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController : UIViewController{
    
    var user :User?
    
    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var nome: UILabel!
    @IBOutlet var tags: UILabel!
    
    var base64String: NSString?
    
    @IBOutlet var descricao: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageUser?.layer.cornerRadius = self.imageUser.frame.size.height/2.0
        self.imageUser.layer.masksToBounds = true
//        self.imageUser.layer.borderWidth = CGFloat(2)
//        self.imageUser.layer.borderColor = Colors.Rosa.CGColor
//        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = user?.name
        
        self.imageUser.image = user?.image
        self.nome.text = user?.name
        self.tags.text = user?.tags
        self.descricao.text = user?.descricao
    }
    
    @IBAction func actionMensagem(sender: AnyObject) {
        CreatAChat(self.user?.image, name: self.user?.name, id:self.user!.id, tags: self.user!.tags)
    }
    
    func CreatAChat(image: UIImage!, name:String!, id: Int, tags: String){
        
        var messagesRef = Firebase(url: String(format: "https://hackathonfiesp.firebaseio.com/Mensagem"))
        
        var uploadImage = image
        
        var imageData: NSData = UIImagePNGRepresentation(uploadImage)
        
        self.base64String = imageData.base64EncodedStringWithOptions(.allZeros)
        
        
        messagesRef.childByAppendingPath(String(id)).setValue([
            "imageConversa": self.base64String!,
            "nome":name,
            "id":id,
            "tags": tags
            ])
        
//        var messagesRefID = Firebase(url: String(format: "https://hackathonfiesp.firebaseio.com/Users"))
//        
//        messagesRefID.childByAppendingPath("id").setValue(["id": id])
        
    }
    
    @IBAction func actionRecomendar(sender: AnyObject) {
        
    }
    
    
}