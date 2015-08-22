//
//  ViewController.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 22/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import UIKit
import TwitterKit
import DigitsKit


class LoginViewController: UIViewController {
    
    
    var alertView = AlertJss()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authenticateButton = DGTAuthenticateButton(authenticationCompletion: {
            (session: DGTSession!, error: NSError!) in
            
            if(session != nil){
                var user = User(name: "", email: "")
                self.alertView.danger(self.navigationController!.view, title: "Teste", text: "Oi mih")
                var view = TransitionManager.creatView("home") as! HomeViewController
                view.user = user
                self.navigationController?.pushViewController(view, animated: true)
                
            }else{
                self.alertView.danger(self.navigationController!.view, title: "Error", text: error.localizedDescription)
            }
                    })
        authenticateButton.center = self.view.center
        authenticateButton.center.y -= authenticateButton.frame.height * 2
        self.view.addSubview(authenticateButton)

        let logInButton = TWTRLogInButton { (session, error) in
            if(session != nil){
                var user = User(name: session.userName, email: "")
                self.alertView.danger(self.navigationController!.view, title: "Teste", text: "Oi mih")
                var view = TransitionManager.creatView("home") as! HomeViewController
                view.user = user
                
                var nextView = TransitionManager.creatView("homeNav")
                self.presentViewController(nextView, animated: true, completion: nil)
//                self.navigationController?.pushViewController(nextView, animated: true)
                
            }else{
                self.alertView.danger(self.navigationController!.view, title: "Error", text: error.localizedDescription)
            }
        }
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

