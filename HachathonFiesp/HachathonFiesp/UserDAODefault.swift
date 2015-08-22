//
//  UserDAODefault.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 22/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import Foundation

class UserDAODefault {
    
    
    class func saveLogin(user: User){
        let userFixo = NSUserDefaults.standardUserDefaults()
        userFixo.setBool(true, forKey: UserGlobalConstants.LoggedNow)
        userFixo.setObject(user.name, forKey: UserGlobalConstants.Name)
        userFixo.setObject(user.email, forKey: UserGlobalConstants.Email)
        // userFixo.setObject(user.image, forKey: "user_image")
        userFixo.synchronize()
    }
    
    class func getLoggedUser()->User{
        
        let userFixo = NSUserDefaults.standardUserDefaults()
        var user:User = User()
        
        user.name = (userFixo.objectForKey(UserGlobalConstants.Name) as? String)!
        user.email = (userFixo.objectForKey(UserGlobalConstants.Email) as? String)!
        return user
    }
}