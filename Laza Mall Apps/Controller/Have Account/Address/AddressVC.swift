//
//  AddressVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 06/08/23.
//

import UIKit

class AddressVC: UIViewController {
    
    
    @IBOutlet weak var nameView: UITextField!
    @IBOutlet weak var countryView: UITextField!
    @IBOutlet weak var cityView: UITextField!
    @IBOutlet weak var phoneNumberView: UITextField!
    @IBOutlet weak var savePrimaryAddressView: UISwitch!
    
    let addressViewModel = AddressViewModel()
    var updateAddress: Bool?
    
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
    }
    // MARK: - Func for add new user using API
    func addNewAddressApi() {
        // Mengambil nilai input dari pengguna
        let name = nameView.text ?? ""
        let country = countryView.text ?? ""
        let city = cityView.text ?? ""
        let phone = phoneNumberView.text ?? ""
        let isSwitchOn = savePrimaryAddressView.isOn
        
        // Memanggil fungsi di ViewModel untuk menambahkan alamat pengguna
        addressViewModel.addAddressUser(country: country, city: city, receiverName: name, phoneNumber: phone, isPrimary: isSwitchOn ){ result in
            switch result {
            case .success(let json):
                // Panggil metode untuk berpindah ke view controller selanjutnya
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    ShowAlert.performAlertApi(on: self, title: "Notification", message: "Successfully add new address")
                }
                print("Response JSON New Address User: \(String(describing: json))")
            case .failure(let error):
                // Mengatur penanganan kesalahan API melalui ViewModel dan menampilkan pesan kesalahan
                self.addressViewModel.apiAddress = { status, description in
                    DispatchQueue.main.async {
                        ShowAlert.performAlertApi(on: self, title: status, message: description)
                    }
                }
                print("JSON add new address error: \(error)")
            }
        }
    }
    

    
    
    @IBAction func saveNewAddressBtn(_ sender: Any) {
        addNewAddressApi()
    }
    
    @IBAction func saveAddressSwitchBtn(_ sender: Any) {
    }
    
}
