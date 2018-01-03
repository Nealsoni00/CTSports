//
//  DefaultSportsVC.swift
//  CTSports
//
//  Created by Jack Sharkey on 12/30/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

import UIKit



class DefaultSportsVC: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var swipeMode = false

    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "AppleSDGothicNeo-Bold", size: 17)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent

        self.navigationItem.title = "Default Sports"

//        print(self.defaultSports.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return defaultSports.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultSportCell", for: indexPath) as! DefaultSportCell

        let current = defaultSports[indexPath.row]
        cell.sport.text = current;

        return cell
    }
 

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func add(_ sender: Any) {
        //prep for segur
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "SetSportViewController") as! UINavigationController
        self.present(vc1, animated:true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if self.isEditing == false {
            print("editing false")
            return .delete
        }
        else if self.isEditing && indexPath.row == (defaultSports.count) {
            return .insert
        }
        else {
            return .delete
        }
    }
    
    var curSport: String?
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //Here we define the buttons for the table cell swipe
     
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let certainSport = defaultSports[indexPath.row]
            
            print("Delete \(certainSport)")
            
            //Delete the class
            //Send the delete request to the server
            
            
            if let index = defaultSports.index(of:certainSport) {
                defaultSports.remove(at: index)
                defaults.set(defaultSports, forKey: "allSports")
            }
            self.table.deleteRows(at: [indexPath], with: .automatic)
            if (self.isEditing == false) {
                self.setEditing(false, animated: true)
            }


           
            
            //Upon completion of the delete request reload the table
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
    //These methods allows the swipes to occur
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .insert) {
//            self.performSegue(withIdentifier: "periodSegue", sender: nil)
        }
    }
    
    func addClass() {
        if (self.isEditing == false) {
            self.setEditing(true, animated: false)
        }
//        self.performSegue(withIdentifier: "periodSegue", sender: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        print("set editing \(editing)")
        super.setEditing(editing, animated: true)
        if (!self.swipeMode) {
            if (editing) {
                self.table.allowsSelectionDuringEditing = true
                if (defaultSports != nil){
                    if (defaultSports.count > 0) {
                        self.table.insertRows(at: [IndexPath(row: defaultSports.count, section: 0)], with: .automatic)
                    }
                }
            }
            else {
                if (self.table.numberOfRows(inSection: 0) > defaultSports.count) {
                    self.table.deleteRows(at: [IndexPath(row: defaultSports.count, section: 0)], with: .automatic)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.swipeMode = true
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.swipeMode = false
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        table.reloadData()
    
    }
    

}