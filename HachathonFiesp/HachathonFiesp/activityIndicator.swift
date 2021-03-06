//
//  activityIndicator.swift
//  Pods
//
//  Created by William Alvelos on 22/08/15.
//
//

import Foundation

import Foundation

class activityIndicator {
    
    
    var boxView = UIView()
    
    
    init(view:UINavigationController, texto: String, inverse: Bool, viewController: UIViewController) {
        viewController.view.alpha = 0.5
        var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.color = Colors.Rosa
        activityView.startAnimating()
        
        var textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = Colors.Rosa
        textLabel.text = texto
        
        viewController.view.userInteractionEnabled = false
        
        
        boxView = UIView(frame: CGRect(x: view.view.frame.midX - (textLabel.frame.width/2 + 25), y: view.view.frame.midY - 30, width: 60 + textLabel.frame.width, height: 50))
        boxView.backgroundColor = Colors.Azul
        boxView.alpha = 0.8
        boxView.userInteractionEnabled = false
        boxView.layer.cornerRadius = 10
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        
        if(inverse){
            textLabel.textColor = Colors.Azul
            activityView.color = Colors.Azul
            boxView.backgroundColor = Colors.Rosa
        }
        
        view.view.addSubview(boxView)
    }
    
    func removeActivityViewWithName(view: UIViewController){
        view.view.alpha = 1
        boxView.removeFromSuperview()
        view.view.userInteractionEnabled = true
    }
    
    
    
}
