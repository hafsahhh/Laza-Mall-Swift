//
//  EditAddressVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 28/08/23.
//

import UIKit

class EditAddressVC: UIViewController {

    @IBOutlet weak var nameView: UITextField!{
        didSet{
            nameView.text = name
        }
    }
    @IBOutlet weak var countryView: UITextField!{
        didSet{
            countryView.text = country
        }
    }
    @IBOutlet weak var phoneView: UITextField!{
        didSet{
            phoneView.text = phone
        }
    }
    @IBOutlet weak var addressView: UITextField!{
        didSet{
            addressView.text = addres
        }
    }
    @IBOutlet weak var editAddressSwitchView: UISwitch!
    
    let editAddressViewModel = EditAddressViewModel()
    var userAddress: DataAllAddress?
    var idAddress: Int = 0
    var name: String = ""
    var country: String = ""
    var phone: String = ""
    var addres: String = ""
    
    
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

    }
    // MARK: - Func for edit address using API
    // Di dalam fungsi editAddressApi() di view controller
    func editAddressApi() {
        let name = nameView.text ?? ""
        let country = countryView.text ?? ""
        let phone = phoneView.text ?? ""
        let address = addressView.text ?? ""
        let isSwitchOn = editAddressSwitchView.isOn
        
        guard let addressId = userAddress?.id else {
            print("userAddress is nil, cannot proceed with API call")
            return
        }
        print("Ini adalah address Id \(addressId)")
        
        editAddressViewModel.updateAddress(idAddress: addressId, country: country, city: address, receiverName: name, phoneNumber: phone, isPrimary: isSwitchOn) { result in
            switch result {
            case .success:
                print("sukses edit address")
                // Panggil metode untuk berpindah ke view controller selanjutnya
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    ShowAlert.performAlertApi(on: self, title: "Notification", message: "Successfully edit address")
                }
            case .failure(let error):
                self.editAddressViewModel.apiAddressAlert = { data in
                    DispatchQueue.main.async {
                        ShowAlert.performAlertApi(on: self, title: "status", message: data)
                    }
                }
                print("JSON edit address error: \(error)")
            }
        }
    }


    

    @IBAction func saveEditAddressBtn(_ sender: Any) {
        editAddressApi()
    }
    
}
