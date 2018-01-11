//
//  InitialInstallViewController.swift
//  CTSports
//
//  Created by Jack Sharkey on 1/8/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import UIKit

class InitialInstallViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
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
        vc.view.frame.origin.y = 667;

        //        navigationController?.pushViewController(vc,
//                                                 animated: true)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.frame.origin.y = -90;
        }, completion: {
            (value: Bool) in
            UIView.animate(withDuration: 0.5, animations: {
          

                //            self.present(vc, animated: true, completion: nil)
                self.addChildViewController(vc)
                self.view.addSubview(vc.view)
                vc.didMove(toParentViewController: self)
                vc.view.frame.origin.y -= 667;
           
            
        }, completion: nil)
             })
        
    }
        
    
    
    
    func done() {

        
    }
    
    
    
    

}
