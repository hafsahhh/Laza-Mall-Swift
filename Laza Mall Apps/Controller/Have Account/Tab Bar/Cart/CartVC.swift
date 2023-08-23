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
    @IBOutlet weak var subTotalView: UILabel!
    @IBOutlet weak var shippingTotalView: UILabel!
    @IBOutlet weak var totalView: UILabel!
    
    
    var cartModel: CartResponse?
    var cartsViewModel = CartsViewModel()
    var allSize: AllSize?
    
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
        
        getUserWishlist()
        getSizeAll()
        cartTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserWishlist()
        cartTableView.reloadData()
    }
    
    func getUserWishlist() {
        cartsViewModel.getCarts() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userCarts):
                    if let userCarts = userCarts { // Safely unwrap the optional
                        self.cartModel = userCarts
                        self.subTotalView.text = String(userCarts.data.orderInfo.subTotal)
                        self.shippingTotalView.text = String(userCarts.data.orderInfo.shippingCost)
                        self.totalView.text = String(userCarts.data.orderInfo.total)
                        self.cartTableView.reloadData()
                    }
                case .failure(let error):
                    // Handle the error appropriately
                    print("Error fetching user carts: \(error)")
                }
            }
        }
    }
    
    func getSizeAll(){
        cartsViewModel.getSizeAll { allSize in
            DispatchQueue.main.async { [weak self] in
                self?.allSize = allSize
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
        if cartModel?.data.products.count == 0 {
            emptyDataCart.isHidden = false
        } else {
            emptyDataCart.isHidden = true
        }
        return  cartModel?.data.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cartCell =  tableView.dequeueReusableCell(withIdentifier: "CartTableCell", for: indexPath) as? CartTableCell else { return UITableViewCell() }
        if let cellCarts = cartModel?.data.products[indexPath.row] {
            cartCell.imageProductView.setImageWithPlugin(url: cellCarts.imageURL)
            cartCell.sizeProduct.text = cellCarts.size
            cartCell.brandProductView.text = cellCarts.brandName
            cartCell.quantityLabel.text = String(cellCarts.quantity)
            cartCell.titleProductView.text = cellCarts.productName
            cartCell.priceProductView.text = String(cellCarts.price)
        }
        cartCell.delegate = self
        print("hihihi")
        return cartCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
        
    }
}

extension CartVC: deleteProductInCartProtocol {
    func deleteProductCart(cell: CartTableCell) {
        print("hohoho")
        guard let indexPath = cartTableView.indexPath(for: cell) else {
            print("hahaha")
            return }
        if let cartData = cartModel?.data.products[indexPath.row]
    
        {
            var sizeId = -1
            guard let allSizeData = allSize?.data else { return }
            for index in 0..<allSizeData.count {
                print("ini index:", index)
                if allSizeData[index].size == cartData.size {
                    print("ini ke2 index:", allSizeData[index].size)
                    print("ini ke 3 index", cartData.size)
                    sizeId = allSizeData[index].id
                    break
                }
            }
            print(sizeId)
            print(cartData)
            cartsViewModel.deleteCarts(idProduct: cartData.id, idSize: sizeId) { result in
                switch result {
                case . success(let data):
                    self.cartsViewModel.apiCarts = { status, data in
                        DispatchQueue.main.async {
                            ShowAlert.performAlertApi(on: self, title: status, message: data)
                        }
                    }
                    print("API Response Data Carts: \(String(describing: data))")
                case .failure(let error):
                    self.cartsViewModel.apiCarts = { status, data in
                        DispatchQueue.main.async {
                            ShowAlert.performAlertApi(on: self, title: status, message: data)
                        }
                    }
                    print("API add to carts Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

//cartsViewModel.deleteCarts(idProduct: cartData.id, idSize: sizeId) { result in
//    switch result {
//    case . success(let data):
//        DispatchQueue.main.async {
//            ShowAlert.performAlertApi(on: self, title: "Carts Notification", message: "Successfully Add New Product to Cart")
//        }
//        print("API Response Data Carts: \(String(describing: data))")
//    case .failure(let error):
//        self.cartsViewModel.apiCarts = { status, data in
//            DispatchQueue.main.async {
//                ShowAlert.performAlertApi(on: self, title: status, message: data)
//            }
//        }
//        print("API add to carts Error: \(error.localizedDescription)")
//    }
//}
