//
//  InputScheduleVC.swift
//  CTSports
//
//  Created by Neal Soni on 1/26/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import UIKit
import PopupDialog
import MessageUI

class InputScheduleVC: UIViewController, MFMailComposeViewControllerDelegate {

   
    var navTitle: String?
    
    @IBOutlet weak var textView: UITextView!
    var text: String?
    
    override func viewDidLoad() {
        self.navigationController!.title = self.navTitle ?? ""
        textView.scrollRangeToVisible(NSRange(location:0, length:0))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CopyLinkButton(_ sender: Any) {
        let title = "Link has been coppied to clipboard"
        let message = "Please email link to your athletics director"
        UIPasteboard.general.string = "http://www.casciac.org/scripts/editprac.cgi"

        let popup = PopupDialog(title: title, message: message)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Dismiss") {
            print("You canceled the car dialog.")
        }
        
        popup.addButtons([buttonOne])
        self.present(popup, animated: true, completion: nil)
    }

    @IBAction func emailCoach(_ sender: Any) {
        sendMail("")

    }
    func sendMail(_ address: String) {
        let toRecipents = [address]
        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setToRecipients(toRecipents)
        mc.setSubject("Missing Games Schedule")
        mc.setMessageBody(" \n http://www.casciac.org/scripts/editprac.cgi", isHTML: false)
        self.present(mc, animated: true, completion: nil)
    }
    
}
