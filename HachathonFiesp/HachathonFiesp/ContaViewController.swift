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
    
    @IBOutlet var email: UILabel!
    
    @IBOutlet var tagsUser: UILabel!
    
    @IBOutlet var descricao: UILabel!
    
    @IBOutlet var moedas: UIButton!
    
    @IBOutlet var logOut: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDAODefault.logged()){
            var user = UserDAODefault.getLoggedUser()
            self.nomeUser.text = user.name
            self.tagsUser.text = user.tags
            self.descricao.text = user.descricao
            self.email.text = user.email
        }else{
            ActionError.actionError("Erro", errorMessage: "Você não esta logado", view: self)
            //var view = TransitionManager.creatView("navLogin") as! UINavigationController
            //TransitionManager.changeView("navLogin", animated: false, view: self)
        }
        
        self.navigationController!.navigationBar.translucent = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func logOutbutton(){
        UserDAODefault.logOut()
        var view = TransitionManager.creatView("navLogin")
        self.presentViewController(view, animated: true, completion: nil)
    }
    
    
    @IBAction func actionLogOut(sender: AnyObject) {
        UserDAODefault.logOut()
        var view = TransitionManager.creatView("navLogin")
        self.presentViewController(view , animated: false, completion: nil)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        UIMPConfiguration.addColorAndFontToButton(self.logOut, color: UIColor.redColor(), fontName: FontName.LabelFont, fontSize: 20)
        
        self.nomeUser.tintColor = Colors.Branco
        
        self.tagsUser.tintColor = Colors.Branco
     
        
//        UIMPConfiguration.addColorAndFontToButton(self.moedas, color: Colors.Branco, fontName: FontName.LabelFont, fontSize: 20)
//        
        
        UIMPConfiguration.addBorderToView(self.moedas, color: Colors.Azul, width: 3.0, corner: 36.0)
        
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
