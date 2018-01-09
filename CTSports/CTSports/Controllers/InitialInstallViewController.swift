//
//  InitialInstallViewController.swift
//  CTSports
//
//  Created by Jack Sharkey on 1/8/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import UIKit

class InitialInstallViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SetSchoolVC") as! SetSchoolVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
        
    }
    
    

}
