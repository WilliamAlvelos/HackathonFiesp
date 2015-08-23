//
//  ActionError.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 23/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import Foundation


class ActionError {
    
    init(){
        
    }
    
    
    class func actionError(error: String, errorMessage: String, view: UIViewController){
        
        
        var alertController = UIAlertController(title: error, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
        }
        
        
        alertController.addAction(okAction)
        
        view.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    class func actionWithTextField(error: String, errorMessage:String, placeholder:String, textFieldView: UITextField, view: UIViewController) {
        
        
        var alertController = UIAlertController(title: error, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        var inputTextField: UITextField?
        
        
        alertController.addTextFieldWithConfigurationHandler({ textField -> Void in
            textField.placeholder = placeholder
            inputTextField = textField
        })
        
        
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            textFieldView.text = inputTextField?.text
        }
        
        alertController.addAction(okAction)
        
        view.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    class func actionWithTextFieldSecure(error: String, errorMessage:String, placeholder:String, textFieldView: UITextField, view: UIViewController) {
        
        
        var alertController = UIAlertController(title: error, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        var inputTextField: UITextField?
        
        
        alertController.addTextFieldWithConfigurationHandler({ textField -> Void in
            textField.placeholder = placeholder
            textField.secureTextEntry = true
            inputTextField = textField
        })
        
        
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            textFieldView.text = inputTextField?.text
        }
        
        alertController.addAction(okAction)
        
        
        
        
        view.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
}
