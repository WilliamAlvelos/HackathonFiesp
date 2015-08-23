//
//  ContaViewController.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 23/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import UIKit

class ContaViewController: UIViewController {

    @IBOutlet var imageUser: UIImageView!
    
    @IBOutlet var nomeUser: UILabel!
    
    @IBOutlet var tagsUser: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if(UserDAODefault.logged()){
            var user = UserDAODefault.getLoggedUser()
            self.imageUser.image = user.image
            self.nomeUser.text = user.name
            self.tagsUser.text = user.tags
        }else{
            ActionError.actionError("Erro", errorMessage: "Você não esta logado", view: self)
            //var view = TransitionManager.creatView("navLogin") as! UINavigationController
            //TransitionManager.changeView("navLogin", animated: false, view: self)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionLogOut(sender: AnyObject) {
        UserDAODefault.logOut()
        var view = TransitionManager.creatView("navLogin")
        self.presentViewController(view , animated: false, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
