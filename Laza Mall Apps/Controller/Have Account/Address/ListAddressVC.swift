//
//  ListAddressVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 09/08/23.
//

import UIKit

protocol chooseAddressProtocol: AnyObject{
    func delegateAddress(addressModel: DataAllAddress?)
}

class ListAddressVC: UIViewController {

    @IBOutlet weak var listAddressTableView: UITableView!
    @IBOutlet weak var emptyDataView: UILabel!
    
    var modelAddress: ResponseAllAddress?
    var addressViewModel = ListAddressViewModel()
    var addressUserData = [DataAllAddress]()
    weak var delegate: chooseAddressProtocol?
    var primaryAddress = false
    var isValidToken = false
    
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
        emptyDataView.isHidden = true
        //back button
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
        
        listAddressTableView.delegate = self
        listAddressTableView.dataSource = self
        listAddressTableView.register(ListAddressCellTable.nib(), forCellReuseIdentifier: ListAddressCellTable.identifier)
        
        getAllAddress()
        listAddressTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllAddress()
        listAddressTableView.reloadData()
    }
    
    // MARK: - Func All Address
    func getAllAddress() {
        self.addressUserData.removeAll()
        
        addressViewModel.getAddressUser() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userAddress):
                    if let userAddress = userAddress { // Safely unwrap the optional
                        self.modelAddress = userAddress
                        let primaryAddress = userAddress.data.filter { $0.isPrimary != nil}
                        let nonPrimaryAddress = userAddress.data.filter { $0.isPrimary == nil}
                        let allTypeAddress = primaryAddress + nonPrimaryAddress
//                        self.modelAddress?.data = allTypeAddress
                        self.addressUserData = userAddress.data
                        self.addressUserData = allTypeAddress
                    }
                    
                case .failure(let error):
                    // Handle the error appropriately
                    print("Error fetching user carts: \(error.localizedDescription)")
                }
                self.listAddressTableView.reloadData()
            }
        }
    }
    
    // MARK: - handleMoveToTrash
    func handleMoveToTrash(indexPath: IndexPath) {
        if let addressData = modelAddress?.data[indexPath.row] {
            addressViewModel.deleteAddress(idAddress: addressData.id) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        ShowAlert.performAlertApi(on: self, title: "Notification", message: "Successfully delete Address")
                        self.getAllAddress()
                    }
                    print("API Response delete address successs")
                case .failure(let error):
                    print("API delete address Error: \(error.localizedDescription)")
                }
            }
        }
            
        print("Moved to trash")
    }
    
    // MARK: - handleEditAddress
    func handleEditAddress(indexPath: IndexPath) {
        guard let editAddress = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditAddressVC") as? EditAddressVC else {
            print("Error creating EditAddressVC")
            return
        }
        editAddress.userAddress = addressUserData[indexPath.row]
//        if let addressData = modelAddress?.data?[indexPath.row] {
//            editAddress.name = addressData.receiverName.capitalized
//            editAddress.country = addressData.country.capitalized
//            editAddress.addres = addressData.city.capitalized
//            editAddress.phone = addressData.phoneNumber
//            editAddress.switchPrimary = addressData.isPrimary
//        }
      
        self.navigationController?.pushViewController(editAddress, animated: true)
    }

    
    func editAddress(){
        let addNewAddress = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressVC")
        self.navigationController?.pushViewController(addNewAddress, animated: true)
    }
    
    // MARK: - trailingSwipeActionsConfigurationForRowAt
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .destructive,
                                       title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.handleMoveToTrash(indexPath: indexPath)
            completionHandler(true)
        }
        trash.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            
            self?.handleEditAddress(indexPath: indexPath)
            
            completionHandler(true)
        }
        editAction.backgroundColor = .systemGreen
        
        let configuration = UISwipeActionsConfiguration(actions: [trash, editAction])
        return configuration
    }
    
    @IBAction func addNewAddressBtn(_ sender: Any) {
        let addNewAddress = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressVC")
        self.navigationController?.pushViewController(addNewAddress, animated: true)
    }
    
}

extension ListAddressVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addressUserData.count == 0 {
            emptyDataView.isHidden = false
        } else {
            emptyDataView.isHidden = true
        }
        return addressUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listAddressTableView.dequeueReusableCell(withIdentifier: ListAddressCellTable.identifier, for: indexPath) as? ListAddressCellTable
        else {return UITableViewCell()}
        
        let address = addressUserData[indexPath.row]
        cell.nameAddressView.text = "\(address.receiverName.capitalized) | \(address.phoneNumber)"
        cell.fullAddressView.text = "\(address.city.capitalized) , \(address.country.capitalized)"
        if address.isPrimary == true {
            cell.checklistPrimary.isHidden = false
        } else {
            cell.checklistPrimary.isHidden = true
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = addressUserData[indexPath.row]
        delegate?.delegateAddress(addressModel: address)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
