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
    
    var email = String()
    
    var image = UIImage()
    
    override init(){
    
    }
    
    init(name: String){
        self.name = name
    }
    
    init(name : String  , email: String, image: UIImage){
        self.name = name
        self.email = email
        self.image = image
    }

}
