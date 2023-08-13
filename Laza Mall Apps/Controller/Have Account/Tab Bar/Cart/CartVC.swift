//
//  CartVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 31/07/23.
//

import UIKit

class CartVC: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var emptyDataCart: UILabel!
    
    var cartModel = [CartElement]()
    
    
    //wishlist tab bar
    private func setupTabBarText() {
        let label3 = UILabel()
        label3.numberOfLines = 1
        label3.textAlignment = .center
        label3.text = "Order"
        label3.font = UIFont(name: "inter-Medium", size: 11)
        label3.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "colorBg")
        tabBarItem.selectedImage = UIImage(view: label3)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //func tab Bar action
        setupTabBarText()
        
        // Register the xib for tableview cell cart product
        cartTableView.dataSource = self
        cartTableView.delegate = self
        cartTableView.register(CartTableCell.nib(), forCellReuseIdentifier: CartTableCell.identifier)
        
        
        //panggil ApiAllCart
        ApiAllCart().getData { CartIndex in
            self.cartModel.append(contentsOf: CartIndex)
            self.cartTableView.reloadData()
            for cart in self.cartModel{
                print(cart.products)
            }
        }
    }
    @IBAction func addressBtn(_ sender: Any) {
        let listAddress = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListAddressVC") as! ListAddressVC
        self.navigationController?.pushViewController(listAddress, animated: true)
    }
    
    
    @IBAction func paymentBtn(_ sender: Any) {
        let payemntBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChoosePaymentVC") as! ChoosePaymentVC
        self.navigationController?.pushViewController(payemntBtn, animated: true)
    }
    
    @IBAction func checkoutBtn(_ sender: Any) {
        let checkoutBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CheckoutVC") as! CheckoutVC
        checkoutBtn.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(checkoutBtn, animated: true)
    }
    
}



extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cartModel.count == 0 {
            emptyDataCart.isHidden = false
        } else {
            emptyDataCart.isHidden = true
        }
        return cartModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cartCell =  tableView.dequeueReusableCell(withIdentifier: "CartTableCell", for: indexPath) as? CartTableCell else { return UITableViewCell() }
        cartCell.configure(data: cartModel[indexPath.item])
        return cartCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
        
    }
    
    
}
