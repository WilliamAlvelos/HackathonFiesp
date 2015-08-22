//
//  User.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 22/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import Foundation

class User: NSObject{
    
    var name : String
    
    var email: String
    
    init(name : String  , email: String?=nil){
        self.name = name
        if(email != nil){
            self.email = email!
        }else{
            self.email = ""
        }
    }
    //?=nil
}
