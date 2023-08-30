//
//  VerifyCodeVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 15/08/23.
//

import UIKit
import DPOTPView

class VerifyCodeVC: UIViewController {
    
    
    @IBOutlet weak var codeVerificText: DPOTPView!
    @IBOutlet weak var confirmCodeView: UIButton!
    @IBOutlet weak var timerView: UILabel!
    
    var userEmail: String?
    let verifyCodeViewModel = VerifyPasswordViewModel()
    var totalTime = 300
    var countdownTimer: Timer!
    
    // MARK: - Button back using programmaticly
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
        
        //back button
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
        
        starCountDown()
        // Do any additional setup after loading the view.
    }
    private func starCountDown() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerView.text = "\(timeFormatted(totalTime))"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            countdownTimer.invalidate()
            ShowAlert.performAlertApi(on: self, title: "Warning", message: "time is up, send the verification code again")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Func VerifyApi
    func verifyCodeApi() {
        let codeString = codeVerificText.text ?? ""
        if let userEmail = userEmail {
            verifyCodeViewModel.getCodeVerify(email: userEmail, code: codeString) { result in
                switch result {
                case .success(let json):
                    // Panggil metode untuk berpindah ke view controller selanjutnya
                    DispatchQueue.main.async {
                        self.newPasswordVc()
                    }
                    print("Response JSON: \(String(describing: json))")
                case .failure(let error):
                    self.verifyCodeViewModel.apiVerifyPassAlert = { description in
                        DispatchQueue.main.async {
                            print("Alert showing for failure case - errorMessage: \(description)")
                            ShowAlert.verifyPassApi(on: self, title: "Error Message", message: description)
                        }
                    }
                    print("Error: \(error)")
                    // Handle error appropriately
                }
            }
        }
    }
    
    //untuk jump to new password view controller
    func newPasswordVc(){
        let newPaswordVc = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
        newPaswordVc.navigationItem.hidesBackButton = true
        newPaswordVc.code = codeVerificText.text
        newPaswordVc.email = userEmail
        self.navigationController?.pushViewController(newPaswordVc, animated: true)
    }
    
    @IBAction func confirmCodeBtn(_ sender: Any) {
        verifyCodeApi()
    }
}
