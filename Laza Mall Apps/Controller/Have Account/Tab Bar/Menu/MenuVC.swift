//
//  MenuVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 01/08/23.
//

import UIKit

class MenuVC: UIViewController {
    
    let userDefault = UserDefaults.standard
    let saveDataLogin = "saveDataLogin"
    let userLoginTrue = "loginTrue"
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutBtnOutlet: UIButton!
    @IBOutlet weak var backMenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUsername()
    }
    
    @IBAction func menuCloseBtn(_ sender: UIButton) {
        
    }
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        updateUsername()
    //    }
    
    // MARK: - update username label
    func updateUsername(){
        if let username = UserDefaults.standard.data(forKey: saveDataLogin) {
            let decoder = JSONDecoder()
            if let userDetail = try? decoder.decode(allUser.self, from: username) {
                usernameLabel.text = "Hello \(userDetail.username)"
            }
        } else {
            usernameLabel.text = "Hello, Guest"
        }
    }
    
    
    @IBAction func switchBtnMode(_ sender: UISwitch) {
        
        let appDelegate = UIApplication.shared.windows.first
        if sender.isOn {
            appDelegate?.overrideUserInterfaceStyle = .dark
            return
        }
        appDelegate?.overrideUserInterfaceStyle =  .light
        return
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: saveDataLogin)
        UserDefaults.standard.removeObject(forKey: userLoginTrue)
        let signInBtnAct = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
        signInBtnAct.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(signInBtnAct, animated: true)
    }
    
    @IBAction func wishlistBtn(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarVC") as! UITabBarController
        vc.selectedIndex = 1 // index tabBar
        self.navigationController?.view.window?.windowScene?.keyWindow?.rootViewController = vc
    }
    
    @IBAction func cardsMenuBtn(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarVC") as! UITabBarController
        vc.selectedIndex = 3 // index tabBar
        self.navigationController?.view.window?.windowScene?.keyWindow?.rootViewController = vc
    }
    
}
