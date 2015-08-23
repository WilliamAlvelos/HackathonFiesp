//
//  User.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 22/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject{
    
    var name = String()
    
    var id = Int()
    
    var email = String()
    
    var image = UIImage()
    
    var senha = String()
    
    var descricao = String()
    
    var tags = String()
    
    var moedas = Int()
    
    override init(){
    
    }
    
    init(name: String){
        self.name = name
    }
    
    init(name : String  , email: String, image: UIImage, senha: String){
        self.name = name
        self.email = email
        self.image = image
        self.senha = senha
    }
    
    init(id:Int ,descricao:String, nome: String, image:UIImage, email: String, tags: String, moeda: Int){
        self.id = id
        self.descricao = descricao
        self.name = nome
        self.image = image
        self.email = email
        self.tags = tags
        self.moedas = moeda
    }
    
    
    init(id: Int, nome: String, image:UIImage, tags:String){
        self.id = id
        self.name = nome
        self.image = image
        self.tags = tags
        
    }
    init(id:Int ,descricao:String, nome: String, image:UIImage, email: String, tags: String){
        self.id = id
        self.descricao = descricao
        self.name = nome
        self.image = image
        self.email = email
        self.tags = tags
    }
    

    
    
    
    



}
