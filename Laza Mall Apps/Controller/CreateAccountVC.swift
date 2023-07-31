//
//  CreateAccountVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 25/07/23.
//

import UIKit
import SafariServices

class CreateAccountVC: UIViewController {
    
    
    @IBOutlet weak var facebookBtnOutlet: UIButton!{
        didSet{
            facebookBtnOutlet.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var twitterBtnOutlet: UIButton!{
        didSet{
            twitterBtnOutlet.layer.cornerRadius = 10
        }
    }
    
    
    @IBOutlet weak var googleBtnOutlet: UIButton!{
        didSet{
            googleBtnOutlet.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    
    
    @IBAction func facebookBtnAct(_ sender: Any) {
        if let url = URL(string: "https://www.facebook.com/login/") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    
    @IBAction func twitterBtnAct(_ sender: Any) {
        if let urlTwitter = URL(string: "https://twitter.com/i/flow/login?"){
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let twitterVC = SFSafariViewController(url: urlTwitter, configuration: config)
            present(twitterVC, animated: true)
        }
        
    }
    
    @IBAction func googleBtnAct(_ sender: Any) {
        if let urlGoogle = URL(string: "https://accounts.google.com/InteractiveLogin/signinchooser?"){
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let googleVC = SFSafariViewController(url: urlGoogle, configuration: config)
            present(googleVC, animated: true)
        }
    }
    
    
    
    
    @IBAction func signInBtnAct(_ sender: Any) {
        let signInBtnAct = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        signInBtnAct.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(signInBtnAct, animated: true)
    }
    
    
    @IBAction func createAccBtnAct(_ sender: Any) {
        let createAccountBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(createAccountBtn, animated: true)
        
    }
    
    
    

}
