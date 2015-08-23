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
        //userFixo.setObject(user.image, forKey: UserGlobalConstants.Image)
        userFixo.setObject(user.descricao, forKey: UserGlobalConstants.descricao)
        userFixo.setObject(user.tags, forKey: UserGlobalConstants.tags)
        userFixo.synchronize()
    }
    
    class func logOut(){
        let userFixo = NSUserDefaults.standardUserDefaults()
        userFixo.setBool(false, forKey: UserGlobalConstants.LoggedNow)
        userFixo.synchronize()
    }
    
    class func logged()->Bool{
        let userFixo = NSUserDefaults.standardUserDefaults()
        
        return userFixo.boolForKey(UserGlobalConstants.LoggedNow)
    }
    
    class func getLoggedUser()->User{
        
        let userFixo = NSUserDefaults.standardUserDefaults()
        var user:User = User()
        
        user.name = (userFixo.objectForKey(UserGlobalConstants.Name) as? String)!
        user.email = (userFixo.objectForKey(UserGlobalConstants.Email) as? String)!
        //user.image = (userFixo.objectForKey(UserGlobalConstants.Image) as? UIImage)!
        user.descricao = (userFixo.objectForKey(UserGlobalConstants.descricao) as? String)!
        user.tags = (userFixo.objectForKey(UserGlobalConstants.tags) as? String)!
        
        return user
    }
}