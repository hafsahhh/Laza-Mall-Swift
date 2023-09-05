//
//  HomeNestedVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 01/08/23.
//

import UIKit
import SideMenu
import SnackBar
import JWTDecode

//protocol untuk search bar
protocol searchProductHomeProtocol: AnyObject {
    func searchProdFetch(isActive: Bool, textString: String)
}

class HomeNestedVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var searchHome: UISearchBar!
    @IBOutlet weak var micOutlet: UIButton!
    
    var blurEffectView: UIVisualEffectView?
    var isMenuClicked: Bool = false
    var isValidToken = false
    var searchTextActive: Bool = false
    //weak var delegateSearch : searchProductHomeProtocol?
    var viewModel = HomeViewModel()
    // Variabel untuk mengatur indikator loading circle
    var isLoading = false
    var activityIndicator: UIActivityIndicatorView!
    
    lazy var parentBlurView : UIVisualEffectView = {
        var blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .light)
        let size = CGSize(width: view.frame.size.width/2, height: view.frame.size.height)
        blurView.frame = CGRect(origin: .zero, size: size)
        return blurView
    }()
    
    private func setupTabBarText() {
        let label2 = UILabel()
        label2.numberOfLines = 1
        label2.textAlignment = .center
        label2.text = "Home"
        label2.font = UIFont(name: "inter-Medium", size: 11)
        label2.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "colorBg")
        tabBarItem.selectedImage = UIImage(view: label2)
    }
    
    //Menu Button
    private lazy var menuBtn : UIButton = {
        //call back button
        let menuBtn = UIButton.init(type: .custom)
        menuBtn.setImage(UIImage(named:"Menu"), for: .normal)
        menuBtn.addTarget(self, action: #selector(menuBtnAct), for: .touchUpInside)
        menuBtn.frame = CGRect(x: 20, y: 75, width: 45, height: 45)
        return menuBtn
    }()
    
    //Menu Button
    @objc func menuBtnAct(){
        print("isMenu",isMenuClicked)
        if isMenuClicked {
            isMenuClicked = false
            parentBlurView.isHidden = true
        } else {
            isMenuClicked = true
            parentBlurView.isHidden = false
            sideMenuClicked()
//            performSegue(withIdentifier: "SideMenuNavigationController" , sender: nil)
        }
    }
    
    private func sideMenuClicked() {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
      let sideMenu = SideMenuNavigationController(rootViewController: vc)
      vc.delegate = self
      sideMenu.delegate = self
      sideMenu.presentationStyle = .menuSlideIn
      sideMenu.leftSide = true
      sideMenu.menuWidth = 330
      present(sideMenu, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false

        searchHome.delegate = self
        AppSnackBar.make(in: self.view, message: "Welcome to LAZA MALL", duration: .lengthLong).show()
        //func tab Bar action
        setupTabBarText()
        
        //nampilin menu dan cart button
        view.addSubview(menuBtn)
        view.addSubview(parentBlurView)
        parentBlurView.isHidden = true
        
        //menu button
        let menuBtn = UIBarButtonItem(customView: menuBtn)
        self.navigationItem.leftBarButtonItem  = menuBtn
        
        //hide back button
        navigationItem.hidesBackButton = true
        
        callTableView()
        
        // Inisialisasi indikator pemuatan
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        jwtExpired()
        if isValidToken {
            callTableView()
        }
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = false
        homeTableView.reloadData()
        callTableView()
    }
    
    func callTableView() {
        // Data source dan delegate
        self.homeTableView.dataSource = self
        self.homeTableView.delegate = self
        
        // Daftarkan xib untuk sel tabel kategori
        let cellCatNib = UINib(nibName: "CategoryTableCell", bundle: nil)
        self.homeTableView.register(cellCatNib, forCellReuseIdentifier: "CategoryTableCell")
    
        // Daftarkan xib untuk sel tabel produk
        homeTableView.register(ProductTableCell.nib(), forCellReuseIdentifier: ProductTableCell.identifier)
    }
    
    func jwtExpired() {
        do {
            guard let tokenData = KeychainManager.shared.getAccessToken() else {
                print("token data kosong")
                self.navigationController?.popToRootViewController(animated: false)
                return }
            let jwt = try decode(jwt: tokenData)
            if true {
//            if jwt.expired {
                isValidToken = false
                updateToken()
//            } else {
//                isValidToken = true
            }
            
        } catch {
            print("ini gagal")
        }
    }
    
    
    func updateToken() {
        ApiRefreshToken().apiRefreshToken() { result in
            switch result {
            case .success(let json):
                print("Response JSON: \(String(describing: json))")
            case .failure(let error):
                print("Error update token: \(error)")
                // Tangani error dengan benar
            }
        }
    }
    

}

extension HomeNestedVC: UITableViewDelegate, UITableViewDataSource, productTableCellProtocol, categoryTableCellProtocol {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 1 {
            guard let catCell =  tableView.dequeueReusableCell(withIdentifier: "CategoryTableCell") as? CategoryTableCell else {return UITableViewCell()}
            catCell.reloadTable = { [weak self] in
                self?.homeTableView.reloadData()
                catCell.delegateBrand = self
            }
            
            return catCell
        } else {
            guard let prodCell = tableView.dequeueReusableCell(withIdentifier: ProductTableCell.identifier, for: indexPath) as? ProductTableCell else { return UITableViewCell()}
            prodCell.reloadTable = { [weak self] in
                self?.homeTableView.reloadData()
                prodCell.delegateProductDetail = self
                self?.viewModel.delegateSearch = prodCell
            }
            return prodCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 1 {
            return 150
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func showDetailProduct(product: ProductEntry) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailProVC") as? DetailProVC {
            detailViewController.productId = product.id
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func showDetailBrand(brand: brandAllEntry) {
        let catBrandVc = UIStoryboard(name: "Main", bundle: nil)
        if let brandViewController = catBrandVc.instantiateViewController(withIdentifier: "CategoryBrandVC") as? CategoryBrandVC {
            brandViewController.brandName = brand.name
            self.navigationItem.hidesBackButton = true
            navigationController?.pushViewController(brandViewController, animated: true)
        }
    }
}

extension HomeNestedVC: SideMenuNavigationControllerDelegate {
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        parentBlurView.isHidden = true
    }
}

extension HomeNestedVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.performSearch(with: searchText)
        homeTableView.reloadData()
    }
}

extension HomeNestedVC: protocolTabBarDelegate {
    
    func protocolGoToCart() {
        self.tabBarController?.selectedIndex = 2
        print("berhasil go to cart")
    }
    
    func protocolGoToProfile() {
        self.tabBarController?.selectedIndex = 3
        print("berhasil go to profile")
    }
    
    func protocolGoToChangePassword() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC else { return }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func protocolGoToWishlist() {
        self.tabBarController?.selectedIndex = 1
        print("berhasil go to whislist")
    }
    
}
extension HomeNestedVC: accessSideMenuDelegate {
    func accessSideMenu() {
        sideMenuClicked()
    }
}

