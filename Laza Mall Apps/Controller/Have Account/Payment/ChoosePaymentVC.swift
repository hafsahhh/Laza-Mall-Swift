//
//  ChoosePaymentVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 09/08/23.
//

import UIKit

class ChoosePaymentVC: UIViewController {
    
    private var choosePayment: String = ""
    
    @IBOutlet weak var checkBoxOvoPayView: UIButton!
    {
        didSet{
            checkBoxOvoPayView.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
        
        
    @IBOutlet weak var checkBoxCreditCardView: UIButton!
    {
        didSet{
            checkBoxCreditCardView.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
        @IBOutlet weak var choosePayBtnView: UIButton!

    //Back Button
    private lazy var backBtn : UIButton = {
        //call back button
        let backBtn = UIButton.init(type: .custom)
        backBtn.setImage(UIImage(named:"Back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        backBtn.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        

        return backBtn
    }()

    //Back Button
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
    }
    
    
    @IBAction func gopayBtn(_ sender: UIButton) {
        checkBox1Toggled()
    }
    
    
    @IBAction func creditCardBtn(_ sender: UIButton) {
        checkBox2Toggled()
    }
    
    
    @objc func checkBox1Toggled() {
        if checkBoxOvoPayView.currentImage == UIImage(systemName: "circle"){
            choosePayment = "GoPay"
            checkBoxOvoPayView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkBoxCreditCardView.setImage(UIImage(systemName: "circle"), for: .normal)
        } else {
            checkBoxOvoPayView.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    @objc func checkBox2Toggled() {
        
        if checkBoxCreditCardView.currentImage == UIImage(systemName: "circle"){
            choosePayment = "Credit Card"
            checkBoxCreditCardView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkBoxOvoPayView.setImage(UIImage(systemName: "circle"), for: .normal)
        } else {
            checkBoxCreditCardView.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }



    // Mengubah warna pada button
    @objc func buttonDidChange() {
        
        if checkBoxOvoPayView.isSelected || checkBoxCreditCardView.isSelected{
            choosePayBtnView.isEnabled = true
            choosePayBtnView.backgroundColor = UIColor(named: "ColorBg")
        } else {
            choosePayBtnView.isEnabled = false
            choosePayBtnView.backgroundColor = UIColor(named: "ColorValid")
        }
    }
    
    @IBAction func choosePayBtn(_ sender: UIButton) {
        if choosePayment == "GoPay"{
            let gopayBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GopayVC") as! GopayVC
            self.navigationController?.pushViewController(gopayBtn, animated: true)
        } else if choosePayment == "Credit Card" {
            let choosePayBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PaymentVC") as! PaymentVC
            self.navigationController?.pushViewController(choosePayBtn, animated: true)
        } else {
            ShowAlert.alertChoosePayment(on: self)
        }
    }
    
    
}
