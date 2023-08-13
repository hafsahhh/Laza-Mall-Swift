//
//  ListAddressVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 09/08/23.
//

import UIKit

class ListAddressVC: UIViewController {

    @IBOutlet weak var listAddressTableView: UITableView!
    @IBOutlet weak var emptyDataView: UILabel!
    
    let modelAddress = cellListAddressUser()
    
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
    }

    @IBAction func addNewAddressBtn(_ sender: Any) {
        let addNewAddress = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressVC")
        self.navigationController?.pushViewController(addNewAddress, animated: true)
    }
    
}

extension ListAddressVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if modelAddress.count == 0 {
            emptyDataView.isHidden = false
        } else {
            emptyDataView.isHidden = true
        }
        return modelAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListAddressCellTable.identifier, for: indexPath) as? ListAddressCellTable
        else {return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
