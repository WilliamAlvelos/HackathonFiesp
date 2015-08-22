//
//  Trabalhador.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 22/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import Foundation

class Trabalhador: NSObject {
    
    var name: String?
    var cel : Int?
    var descricao:String?
    var id : Int?
    
    
    init(name: String){
        self.name = name
    }
    init(name: String, cel:Int, descricao: String, id:Int){
        self.name = name
        self.cel = cel
        self.descricao = descricao
        self.id = id
    }
    
}