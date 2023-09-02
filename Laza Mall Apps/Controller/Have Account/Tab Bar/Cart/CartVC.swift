//
//  CartVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 31/07/23.
//

import UIKit

class CartVC: UIViewController{
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var emptyDataCart: UILabel!
    @IBOutlet weak var subTotalView: UILabel!
    @IBOutlet weak var shippingTotalView: UILabel!
    @IBOutlet weak var totalView: UILabel!
    @IBOutlet weak var deliveryAddressView: UILabel!
    @IBOutlet weak var cityAddress: UILabel!
    
    
    var cartModel: CartResponse?
    var cartsViewModel = CartsViewModel()
    var cartAddressViewModel = ListAddressViewModel()
    var allSize: AllSize?
    var modelAddress: ResponseAllAddress?
    var selectedAddress: String = ""
    var selectedCountry: String = ""

    
    
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
        
        getUserCarts()
        getSizeAll()
        cartTableView.reloadData()
        
        //hide back button
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserCarts()
        getSizeAll()
        getAllAddress() 
        cartTableView.reloadData()
    }
    
    func getUserCarts() {
        cartsViewModel.getCarts() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userCarts):
                    if let userCarts = userCarts { // Safely unwrap the optional
                        self.cartModel = userCarts
                        self.subTotalView.text = "$ \(userCarts.data.orderInfo.subTotal)"
                        self.shippingTotalView.text = "$ \(userCarts.data.orderInfo.shippingCost)"
                        self.totalView.text = "$ \(userCarts.data.orderInfo.total)"
                    }
                    self.cartTableView.reloadData()
                    print("ini keranjabg")
                case .failure(let error):
                    // Handle the error appropriately
                    print("Error fetching user carts: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Func All Address
    func getAllAddress() {
        cartAddressViewModel.getAddressUser() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userAddress):
                    self.modelAddress = userAddress
                    self.updatePrimaryAddress()
                    print("address user primary")
                case .failure(let error):
                    // Handle the error appropriately
                    print("Error fetching address user: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updatePrimaryAddress() {
        if !selectedAddress.isEmpty && !selectedCountry.isEmpty {
            // Gunakan alamat yang dipilih melalui protocol jika ada
            self.deliveryAddressView.text = selectedCountry
            self.cityAddress.text = selectedAddress
        } else if let primaryAddress = modelAddress?.data?.first(where: { $0.isPrimary == true }) {
            // Gunakan alamat utama jika alamat yang dipilih tidak ada
            self.deliveryAddressView.text = primaryAddress.country.capitalized
            self.cityAddress.text = primaryAddress.city.capitalized
        } else {
            // Tampilkan teks "No Address" jika tidak ada alamat utama atau alamat yang dipilih
            self.deliveryAddressView.text = "No Address"
            self.cityAddress.text = "No Address"
            print("Tidak ada alamat utama atau alamat yang dipilih")
        }
    }

    func getSizeAll(){
        cartsViewModel.getSizeAll { allSize in
            DispatchQueue.main.async { [weak self] in
                self?.allSize = allSize
            }
        }
    }
    
    func getSizeId(forSize size: String) -> Int{
        var sizeId = -1
        guard let allSizeData = allSize?.data else { return sizeId }
        for index in 0..<allSizeData.count {
            if allSizeData[index].size == size {
                sizeId = allSizeData[index].id
                break
            }
        }
        return sizeId
    }
    
    
    
    @IBAction func addressBtn(_ sender: Any) {
        let listAddress = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListAddressVC") as! ListAddressVC
        listAddress.delegate = self
        self.navigationController?.pushViewController(listAddress, animated: true)
    }
    
    
    @IBAction func paymentBtn(_ sender: Any) {
        let payemntBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
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
        if cartModel?.data.products.count == nil {
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
            cartCell.priceProductView.text = "$ \(cellCarts.price)"
        }
        cartCell.delegate = self
        return cartCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
        
    }
}

extension CartVC: productInCartProtocol, chooseAddressProtocol {
    
    func delegateAddress(country: String, address: String) {
        deliveryAddressView.text = address
        selectedAddress = address
        
        cityAddress.text = country
        selectedCountry = country
    }
//    if let firstAddress = modelAddress?.data?.first {
//        self.deliveryAddressView.text = firstAddress.country
//        self.cityAddress.text = firstAddress.city
//    }
    
    func updateCountProduct(cell: CartTableCell, completion: @escaping (Int) -> Void) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        if let cartData = cartModel?.data.products[indexPath.row] {
            completion(cartData.quantity)
        }
    }
    
    func deleteProductCart(cell: CartTableCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else {
            return }
        if let cartData = cartModel?.data.products[indexPath.row]
        {
            let getSizeId = getSizeId(forSize: cartData.size)
            cartsViewModel.deleteCarts(idProduct: cartData.id, idSize: getSizeId) { result in
                switch result {
                case . success(let data):
                    self.getUserCarts()
                    DispatchQueue.main.async {
                        ShowAlert.performAlertApi(on: self, title: "Carts Notification", message: "Successfully delete product")
                    }
                    print("API Response delete Carts: \(String(describing: data))")
                case .failure(let error):
                    self.cartsViewModel.apiCarts = { status, data in
                        DispatchQueue.main.async {
                            ShowAlert.performAlertApi(on: self, title: status, message: data)
                        }
                    }
                    print("API add to delete Error: \(error.localizedDescription)")
                }
            }
        } else {
            print("hello ini delete")
        }
    }
    
    func arrowDownProductCart(cell: CartTableCell, completion: @escaping (Int) -> Void) {
        guard let indexPath = cartTableView.indexPath(for: cell) else {
            return }
        if let cartData = cartModel?.data.products[indexPath.row]
        {
            let getSizeId = getSizeId(forSize: cartData.size)
            cartsViewModel.updateCarts(idProduct: cartData.id, idSize: getSizeId) { result in
                switch result {
                case . success(let data):
                    self.getUserCarts()
                    completion(cartData.quantity)
                    print("API Response deacrese Data Carts: \(String(describing: data))")
                case .failure(let error):
                    self.cartsViewModel.apiCarts = { status, data in
                        DispatchQueue.main.async {
                            ShowAlert.performAlertApi(on: self, title: status, message: data)
                        }
                    }
                    print("API deacrese to carts Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func arrowUpProductCart(cell: CartTableCell, completion: @escaping (Int) -> Void) {
        guard let indexPath = cartTableView.indexPath(for: cell) else {
            return }
        if let cartData = cartModel?.data.products[indexPath.row]
        {
            let getSizeId = getSizeId(forSize: cartData.size)
            cartsViewModel.arrowUpQuantityCart(idProduct: cartData.id, idSize: getSizeId) { result in
                switch result {
                case . success(let data):
                    self.getUserCarts()
                    completion(cartData.quantity)
                    print("API Response increase Data Carts: \(String(describing: data))")
                case .failure(let error):
                    self.cartsViewModel.apiCarts = { status, data in
                        DispatchQueue.main.async {
                            ShowAlert.performAlertApi(on: self, title: status, message: data)
                        }
                    }
                    print("API increase to carts Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
