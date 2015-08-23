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
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    
    var alertView = AlertJss()
    
    
    
    @IBAction func buttonTwitterTouch(sender: AnyObject) {
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if(session != nil){
                var user = User(name: session.userName)
                var view = TransitionManager.creatView("register") as! RegisterViewController
                view.user = user
                self.navigationController?.pushViewController(view, animated: true)
                //                self.navigationController?.pushViewController(nextView, animated: true)
            }else{
                self.alertView.danger(self.navigationController!.view, title: "Error", text: error.localizedDescription, buttonText: "Ok")
            }
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.title = "Login"
        
        self.navigationController!.navigationBar.hidden = true
        
        self.view.backgroundColor = Colors.Azul
        
        self.navigationController!.navigationBar.barTintColor = Colors.Azul
        
        self.navigationController!.navigationBar.tintColor = Colors.Branco
        
        
        let textAttributes = NSMutableDictionary(capacity:1)
        textAttributes.setObject(Colors.Branco, forKey: NSForegroundColorAttributeName)
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSObject : AnyObject]
        
        

        
        
//        var loginButton = FBSDKLoginButton()
//        loginButton.center = self.view.center
//        loginButton.center.y += loginButton.frame.height * 2
//        loginButton.actionsForTarget("btnFBLoginPressed:", forControlEvent: UIControlEvents.AllEvents)
//        self.view.addSubview(loginButton)
        
//        let authenticateButton = DGTAuthenticateButton(authenticationCompletion: {
//            (session: DGTSession!, error: NSError!) in
//            
//
//        })
//        authenticateButton.center = self.view.center
//        authenticateButton.center.y -= authenticateButton.frame.height * 2
//        self.view.addSubview(authenticateButton)

//        let logInButton = TWTRLogInButton { (session, error) in
//            if(session != nil){
//                var user = User(name: session.userName)
//                var view = TransitionManager.creatView("register") as! RegisterViewController
//                view.user = user
//                self.navigationController?.pushViewController(view, animated: true)
////                self.navigationController?.pushViewController(nextView, animated: true)
//            }else{
//                self.alertView.danger(self.navigationController!.view, title: "Error", text: error.localizedDescription, buttonText: "Ok")
//            }
//        }
//        logInButton.center = self.view.center
//        self.view.addSubview(logInButton)
    }
    
    
    @IBAction func btnFBLoginPressed(sender: AnyObject) {
        var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            if (error == nil){
                var fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    fbLoginManager.logOut()
                }
            }
        })
    }
    
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if ((error) != nil)
                {
                    // Process error
                    println("Error: \(error)")
                }
                else
                {
                    var id = result.valueForKey("id") as! String
                    var name = result.valueForKey("name") as! String
                    var email = result.valueForKey("email") as! String
                    var image = "https://graph.facebook.com/\(id)/picture?type=large"
                    
                    
                    var imageFacebook : UIImage?
                    
                    let url = NSURL(string: image)
                    
                    var request = NSMutableURLRequest(URL: url!)
                    request.timeoutInterval = 5
                    var response: NSURLResponse?
                    var error: NSError?
                    let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
                    if urlData == nil || error != nil || NSString(data: urlData!, encoding: NSUTF8StringEncoding) != nil{
                        imageFacebook = UIImage(named: "logo")
                        
                    }
                    imageFacebook = UIImage(data: urlData!)
                    
                    let nextView = TransitionManager.creatView("register") as! RegisterViewController
                    let user = User()
                    user.name = name
                    user.email = email
                    user.image = imageFacebook!
                    nextView.user = user
                    
                    
                    self.navigationController?.pushViewController(nextView, animated: true)
                    
                }
            })
        }
    }

    @IBAction func actionSkip(sender: AnyObject) {
        
        var view = TransitionManager.creatView("homeNav")
        self.presentViewController(view, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

