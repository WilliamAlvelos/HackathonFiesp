//
//  ProfileViewController.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 22/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import Foundation
import UIKit
class ProfileViewController : UIViewController{
    
    var user :User?
    
    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var nome: UILabel!
    @IBOutlet var tags: UILabel!
    
    @IBOutlet var descricao: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageUser?.layer.cornerRadius = self.imageUser.frame.size.height/2.0
        self.imageUser.layer.masksToBounds = true
        self.imageUser.layer.borderWidth = CGFloat(2)
        self.imageUser.layer.borderColor = Colors.Rosa.CGColor
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        
        self.imageUser.image = user?.image
        self.nome.text = user?.name
        self.tags.text = user?.tags
        self.descricao.text = user?.descricao
    }
    
    @IBAction func actionMensagem(sender: AnyObject) {
        
    }
    @IBAction func actionRecomendar(sender: AnyObject) {
        
    }
    
    
}