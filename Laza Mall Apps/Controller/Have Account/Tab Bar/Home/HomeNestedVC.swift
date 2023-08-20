//
//  HomeNestedVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 01/08/23.
//

import UIKit
import SideMenu
import SnackBar

//protocol untuk search bar
protocol searchProductHomeProtocol: AnyObject {
    func searchProdFetch(isActive: Bool, textString: String)
}

class HomeNestedVC: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var searchHome: UISearchBar!
    @IBOutlet weak var micOutlet: UIButton!
    
    var blurEffectView: UIVisualEffectView?
    var isMenuClicked: Bool = false
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
            performSegue(withIdentifier: "SideMenuNavigationController" , sender: nil)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // datasource and delegate
        self.homeTableView.dataSource = self
        self.homeTableView.delegate = self
        
        // Register the xib for tableview cell category
        let cellCatNib = UINib(nibName: "CategoryTableCell", bundle: nil)
        self.homeTableView.register(cellCatNib, forCellReuseIdentifier: "CategoryTableCell")
    
        // Register the xib for tableview cell product
        homeTableView.register(ProductTableCell.nib(), forCellReuseIdentifier: ProductTableCell.identifier)
        
        // Inisialisasi indikator pemuatan
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
//                    tableView.dequeueReusableCell(withIdentifier: "ProductTableCell") as? CategoryTableCell else {return UITableViewCell()}
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
            brandViewController.brandId = brand.id
            print("IDBrand \(brand.id)")
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
