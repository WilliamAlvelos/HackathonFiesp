//
//  ConversasTableViewController.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 23/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import UIKit
import Firebase

class ConversasTableViewController: UITableViewController,UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating{

    
    var conversas:Array<User> = Array()
    var filteredTableData:Array<User> = Array()
    var resultSearchController = UISearchController()
    var avatars = NSMutableDictionary()
    var refreshControle: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController!.tabBar.barTintColor = UIColor(red: 13/255, green: 21/255, blue: 36/255, alpha: 1)
        
        self.navigationController?.navigationBar.barTintColor = Colors.Azul
        self.navigationController?.navigationBar.translucent = false
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            controller.searchResultsUpdater = self
            controller.searchBar.backgroundColor = Colors.Azul
            controller.searchBar.barTintColor = Colors.Azul
            self.tableView.tableHeaderView = controller.searchBar
            controller.searchBar.tintColor = Colors.Branco
            return controller
        })()
        
        self.refreshControle = UIRefreshControl()
        self.refreshControle?.backgroundColor = Colors.Azul
        self.refreshControle?.tintColor = Colors.Branco
        self.refreshControle?.addTarget(self, action: Selector("reloadData"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(self.refreshControle!)
        
        
        setupFirebase()
        
    }
    
    func reloadData(){
        animateTable()
        self.refreshControle?.endRefreshing()
    }
    
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells()
        let tableWidth: CGFloat = tableView.bounds.size.width
        for i in cells {
            let cell: UITableViewCell = i as! UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(tableWidth, 0)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as! UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    
    
    func setupFirebase(){
        
        var ref = Firebase(url: String(format: "https://hackathonfiesp.firebaseio.com/Mensagem"))
        
        ref.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) -> Void in
            var id = snapshot.value["id"] as! Int
            var nome = snapshot.value["nome"] as? String
            var image = snapshot.value["imageConversa"] as? String
            var tags = snapshot.value["tags"] as? String
            
            
            if(tags != nil){
                var decodedData = NSData(base64EncodedString: image!, options: NSDataBase64DecodingOptions())
                var decodedImage = UIImage(data: decodedData!)!
                
                
                var user = User(id: id, nome: nome!, image: decodedImage, tags: tags!)
                
                self.conversas.append(user)
            }
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            return self.conversas.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("conversaCell", forIndexPath: indexPath) as! ConversaTableViewCell
        
        
        if (self.resultSearchController.active) {
            cell.imagem.image = self.filteredTableData[indexPath.row].image
            cell.labelNome.text = self.filteredTableData[indexPath.row].name
            cell.labelTags.text = self.filteredTableData[indexPath.row].tags
            
            return cell
        }
        else {
            
            cell.imagem.image = self.conversas[indexPath.row].image
            cell.labelNome.text = self.conversas[indexPath.row].name
            cell.labelTags.text = self.conversas[indexPath.row].tags
            
            
            return cell
        }
        
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if(self.resultSearchController.active){

            var view = TransitionManager.creatView("chatView") as! ChatViewController
            var user = self.conversas[indexPath.row]
            
            self.avatars.removeAllObjects()
            var usuario :JSQMessagesAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(self.filteredTableData[indexPath.row].image, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
            self.avatars.setValue(usuario, forKey: "\(user.id)")
            view.avatars = self.avatars
            view.conversa = indexPath.row
            view.name = self.conversas[indexPath.row].name
            self.navigationController?.pushViewController(view, animated: true)
            
        }else{
            
            var view = TransitionManager.creatView("chatView") as! ChatViewController
            var user = self.conversas[indexPath.row]
            
            self.avatars.removeAllObjects()
            var usuario :JSQMessagesAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(self.conversas[indexPath.row].image, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
             self.avatars.setValue(usuario, forKey: "\(user.id)")
            view.avatars = self.avatars
            view.conversa = indexPath.row
            view.name = self.conversas[indexPath.row].name
            self.navigationController?.pushViewController(view, animated: true)
        }
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let sb = searchController.searchBar
        let target = sb.text
        self.filteredTableData = self.conversas.filter {
            s in
            let options = NSStringCompareOptions.CaseInsensitiveSearch
            let found = s.tags.rangeOfString(target, options: options)
            return (found != nil)
        }
        self.tableView.reloadData()
    }

}
