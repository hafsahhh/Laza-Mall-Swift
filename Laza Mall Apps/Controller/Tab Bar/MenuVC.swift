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

    @IBAction func logoutBtn(_ sender: Any) {
    }
    

}
