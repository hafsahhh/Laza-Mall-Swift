//
//  Screen1VC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 25/07/23.
//

import UIKit

class Screen1VC: UIViewController {
    
    
    @IBOutlet weak var lookViewOutlet: UIView!{
        didSet{
            lookViewOutlet.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
        }
    }
    
    @IBOutlet weak var womenBtnOutlet: UIButton!{
        didSet{
            womenBtnOutlet.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var menBtnOutlet: UIButton!{
        didSet{
            menBtnOutlet.layer.cornerRadius = 10
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func womenBtnAct(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.tintColor = .white
        if sender.isSelected{
            sender.backgroundColor = UIColor(named: "ColorBg" )
            sender.setTitleColor(UIColor.white, for: .normal)
        }
        else{
            sender.backgroundColor = UIColor(named: "ColorValid" )
            sender.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    @IBAction func menBtnAct(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.tintColor = .white
        if sender.isSelected{
            sender.backgroundColor = UIColor(named: "ColorBg" )
            sender.setTitleColor(UIColor.white, for: .normal)
        }
        else{
            sender.backgroundColor = UIColor(named: "ColorValid" )
            sender.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    

    @IBAction func skipBtnAct(_ sender: Any) {
        let skipBtnCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
        skipBtnCtrl.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(skipBtnCtrl, animated: true)
//        let skipBtnCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
//        skipBtnCtrl.navigationItem.hidesBackButton = true
//        self.navigationController?.pushViewController(skipBtnCtrl, animated: true)
    }
}
