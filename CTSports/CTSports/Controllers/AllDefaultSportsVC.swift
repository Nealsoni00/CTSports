//
//  AllDefaultSportsVCTableViewController.swift
//  
//
//  Created by Jack Sharkey on 12/22/17.
//

import UIKit

class AllDefaultSportsVCTableViewController: UITableViewController {
    
    var defaultSports: [DefaultSport]?
    var swipeMode = false

    

    override func viewDidLoad() {
        super.viewDidLoad()

        let sweetBlue = UIColor(red:0.13, green:0.42, blue:0.81, alpha:1.0)
        
        //Turn off extra lines in the table view
        
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "AppleSDGothicNeo-Bold", size: 17)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationItem.title = "YOUR SPORTS"

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.swipeMode = true
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.swipeMode = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
   return 1
    }



}
