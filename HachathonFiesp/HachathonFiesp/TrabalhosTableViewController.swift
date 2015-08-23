//
//  TrabalhosTableViewController.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 22/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import UIKit
import Firebase

class TrabalhosTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate,UISearchResultsUpdating{
    
    var trabalhos:Array<User> = Array()
    var filteredTableData:Array<User> = Array()

    var resultSearchController = UISearchController()
    
    var refreshControle: UIRefreshControl?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = Colors.Branco
        

        self.tabBarController!.tabBar.barTintColor = UIColor(red: 13/255, green: 21/255, blue: 36/255, alpha: 1)
        
        self.navigationController?.navigationBar.barTintColor = Colors.Azul
        self.navigationController?.navigationBar.translucent = true
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            controller.searchBar.placeholder = "Pesquise pelo serviço desejado"
            controller.searchResultsUpdater = self
            controller.searchBar.backgroundColor = Colors.Azul
            controller.searchBar.barTintColor = Colors.Azul
            self.tableView.tableHeaderView = controller.searchBar
            controller.searchBar.tintColor = Colors.Branco
            return controller
        })()
        
        
        self.navigationController!.navigationBar.tintColor = Colors.Branco
        self.navigationController!.navigationBar.barTintColor = Colors.Azul
        self.refreshControle = UIRefreshControl()
        self.refreshControle?.backgroundColor = Colors.Azul
        self.refreshControle?.tintColor = Colors.Branco
        self.refreshControle?.addTarget(self, action: Selector("reloadData"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(self.refreshControle!)

        
        setupFirebase()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func reloadData(){
        self.tableView.reloadData()
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
        
        var ref = Firebase(url: String(format: "https://hackathonfiesp.firebaseio.com/Users"))
        
        ref.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) -> Void in
            var id = snapshot.value["id"] as! Int
            var descricao = snapshot.value["descricao"] as? String
            var nome = snapshot.value["nome"] as? String
            var image = snapshot.value["imageUser"] as? String
            var email = snapshot.value["email"] as? String
            var tags = snapshot.value["tags"] as? String
            var moedas = snapshot.value["moeda"] as? Int
            
            
            if(descricao != nil){
                var decodedData = NSData(base64EncodedString: image!, options: NSDataBase64DecodingOptions())
                var decodedImage = UIImage(data: decodedData!)!
                
                var user = User(id: id, descricao: descricao!, nome: nome!, image: decodedImage, email: email!, tags: tags!)
                
                self.trabalhos.append(user)
                
                self.tableView.reloadData()
            }
        })
        
        
        
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(self.resultSearchController.active){
            var view = TransitionManager.creatView("profileView") as! ProfileViewController
            var user = self.filteredTableData[indexPath.row]
            view.user = user
            self.navigationController?.pushViewController(view, animated: true)
        
        }else{
            var view = TransitionManager.creatView("profileView") as! ProfileViewController
            var user = self.trabalhos[indexPath.row]
            view.user = user
            self.navigationController?.pushViewController(view, animated: true)
        }
        

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
            return self.trabalhos.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! CustomTableViewCell
        

        
        
        if (self.resultSearchController.active) {
            
            cell.nome.text = self.filteredTableData[indexPath.row].name
            cell.email.text = self.filteredTableData[indexPath.row].email
            cell.image2.image = self.filteredTableData[indexPath.row].image
            cell.descricao.text = self.filteredTableData[indexPath.row].descricao
            cell.tags.text = self.filteredTableData[indexPath.row].tags
            
            return cell
        }
        else {
            
            cell.nome.text = self.trabalhos[indexPath.row].name
            cell.email.text = self.trabalhos[indexPath.row].email
            cell.image2.image = self.trabalhos[indexPath.row].image
            cell.descricao.text = self.trabalhos[indexPath.row].descricao
            cell.tags.text = self.trabalhos[indexPath.row].tags
            
            return cell
        }
        

        // Configure the cell...

    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let sb = searchController.searchBar
        let target = sb.text
        self.filteredTableData = self.trabalhos.filter {
            s in
            let options = NSStringCompareOptions.CaseInsensitiveSearch
            let found = s.tags.rangeOfString(target, options: options)
            return (found != nil)
        }
        self.tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
