//
//  InfoVC.swift
//  CTSports
//
//  Created by Neal Soni on 12/17/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

import UIKit
import MessageUI

class InfoViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    //    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var defaultSchoolLabel: UILabel!
    @IBOutlet weak var defaultSportLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "AppleSDGothicNeo-Bold", size: 17)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        let backButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.title = "About"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        defaultSportLabel.text = "Change Default Sport From: \(sportKey)"
        defaultSchoolLabel.text = "Change Default School From: \(schoolKey)"
        self.navigationController?.navigationBar.barTintColor = sweetBlue

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            switch indexPath.row {
            case 2:
                let VC1 = self.storyboard?.instantiateViewController(withIdentifier: "SetSchoolViewController") as! UINavigationController
                self.present(VC1, animated:true, completion: nil)
            case 4:
                if let url = URL(string: "http://www.casciac.org/scripts/editprac.cgi") {
                    UIApplication.shared.open(url, options: [:])
                }
                tableView.deselectRow(at: indexPath, animated: true)
            default:
                break
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0: //Neal
                sendMail("nealsoni00@gmail.com")
                tableView.deselectRow(at: indexPath, animated: true)
            case 1: //Jack
                sendMail("sharkeyjack11@gmail.com")
                tableView.deselectRow(at: indexPath, animated: true)
            case 2: //Alex
                sendMail("sharkeyjack11@gmail.com")
                tableView.deselectRow(at: indexPath, animated: true)
            case 3: //Emily
                sendMail("sharkeyjack11@gmail.com")
                tableView.deselectRow(at: indexPath, animated: true)
            case 4: //Ian
                sendMail("sharkeyjack11@gmail.com")
                tableView.deselectRow(at: indexPath, animated: true)
            case 4: //Bidgood
                sendMail("sharkeyjack11@gmail.com")
                tableView.deselectRow(at: indexPath, animated: true)
            case 4: //CIAC
                sendMail("sharkeyjack11@gmail.com")
                tableView.deselectRow(at: indexPath, animated: true)
            default:
                break
            }
        }
        
    }
    
    func sendMail(_ address: String) {
        let toRecipents = [address]
        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setToRecipients(toRecipents)
        mc.setSubject("CT CIAC Sports Schedule")
        
        //TODO: CHECK IF MAIL VC IS PRESENTED ON iPHONE!
        self.present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    //Set the text for the two info things
    
    let aboutText = "CT Sports is an app that shows the game schedule of all varsity level sports. This app pulls the information for game dates and times from the CIAC website. If there are any issues with the schedule, please contact your high school's sports director and let them know."
    
    let securityText = "This app works by logging you in to our servers through a token generated by a Google OAuth login. As Google OAuth is utilized, passwords are NOT NOR COULD BE at any time stored or accessed by this app. Google handles all credentials, thus the security of this app is the security of a Google log in. \n \nBy using this app, you agree that anonymous analytic data may be collected to help improve future use of iStaples."
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "aboutSegue" {
            let newView = segue.destination as! AboutVC
            
            newView.title = "About CTSports"
            newView.text = aboutText
        }
            
        else if segue.identifier == "securitySegue" {
            let newView = segue.destination as! AboutVC
            
            newView.title = "Security Information"
            newView.text = securityText
        }
    }
    
}

