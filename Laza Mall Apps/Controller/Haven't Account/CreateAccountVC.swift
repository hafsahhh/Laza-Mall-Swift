//
//  CreateAccountVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 25/07/23.
//

import UIKit
import SafariServices
import GoogleSignIn

class CreateAccountVC: UIViewController {
    
    @IBOutlet weak var labelGetStarted: UILabel!
    
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
    
    let loginTrue = "loginTrue"
    let signUpTrue = "signUpTrue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        // untuk stay ketika sudah login di awal, jadi user defaultnya sudah tersimpan
        //        if UserDefaults.standard.bool(forKey: loginTrue){
        //            let tabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
        //            tabbarVC.navigationItem.hidesBackButton = true
        //            self.navigationController?.pushViewController(tabbarVC, animated: true)
        //        }
        
        navigationItem.hidesBackButton = true
        
        // untuk stay ketika sudah login di awal, jadi user defaultnya sudah tersimpan
        if UserDefaults.standard.bool(forKey: "loginTrue"){
            let tabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
            tabbarVC.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(tabbarVC, animated: true)
        }
        
        
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
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            
            // If sign in succeeded, display the app's main content View.
            print("Sign in success: \(String(describing: signInResult.user.profile?.email))")
            
        }
        updateScreen()
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
    
    private func updateScreen() {
        
        if let user = GIDSignIn.sharedInstance.currentUser {
            // User signed in
            
            // Show greeting message
            guard let userName = user.profile?.name else {return}
            labelGetStarted.text = "Hello \(userName)"
            
            // Hide sign in button
            googleBtnOutlet.isHidden = true
    
            
        } else {
             
             // Show sign in button
            googleBtnOutlet.isHidden = false
        }
    }
    
    
}
