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
    
    @IBOutlet var mensagem: UIButton!
    var base64String: NSString?
    @IBOutlet var recomendar: UIButton!
    
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
        
        self.imageUser.image = user?.image
        self.nome.text = user?.name
        self.tags.text = user?.tags
        self.descricao.text = user?.descricao
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        UIMPConfiguration.addBorderToView(self.mensagem, color: Colors.Azul, width: 3.0, corner: 36.0)
        UIMPConfiguration.addBorderToView(self.recomendar, color: Colors.Azul, width: 3.0, corner: 36.0)
        //        UIMPConfiguration.addColorAndFontToButton(self.emailTextField, color: Colors.Rosa, fontName: FontName.ButtonFont, fontSize: 20)

        
//        
//        UIMPConfiguration.addColorAndFontToButton(self.mensagem, color: Colors.Azul, fontName: FontName.LabelFont, fontSize: 20)
//        
//        UIMPConfiguration.addColorAndFontToButton(self.recomendar, color: Colors.Azul, fontName: FontName.LabelFont, fontSize: 20)
        
    }
    

    
    @IBAction func actionMensagem(sender: AnyObject) {
        
        if(UserDAODefault.logged()){
            CreatAChat(self.user?.image, name: self.user?.name, id:self.user!.id, tags: self.user!.tags)
        }else{
            ActionError.actionError("Erro", errorMessage: "Você não esta logado", view: self)
        }
        
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
        ActionError.actionError("Parabéns", errorMessage: "Você recomendou com sucesso", view: self)
    }
    
    
}