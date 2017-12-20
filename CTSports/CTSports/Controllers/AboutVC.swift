//
//  AboutVC.swift
//  CTSports
//
//  Created by Neal Soni on 12/17/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//
import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var textField: UITextView!
    
    var navTitle: String?
    
    var text: String?
    
    override func viewDidLoad() {
        self.navigationController!.title = self.navTitle ?? ""
        
        textField.text = self.text ?? ""
    }
}

