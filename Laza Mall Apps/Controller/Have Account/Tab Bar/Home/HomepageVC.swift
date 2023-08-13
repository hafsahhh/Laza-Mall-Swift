//
//  HomepageVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 31/07/23.
//

import UIKit

class HomepageVC: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var catagoryBrand: UICollectionView!
    @IBOutlet weak var productCollectCellView: UICollectionView!
    
    var catModel = categoryIndex()
    var productModel = [ProductEntry]()
    var productFilter: [ProductEntry] = []
    var searchActive : Bool = false
    
    
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
        menuBtn.frame = CGRect(x: 20, y: 90, width: 45, height: 45)
        return menuBtn
    }()
    
    //Menu Button
    @objc func menuBtnAct(){
        print("bau")
    }
    
    //Cart Button
    private lazy var cartBtn : UIButton = {
        //call back button
        let cartBtn = UIButton.init(type: .custom)
        cartBtn.setImage(UIImage(named:"Cart"), for: .normal)
        cartBtn.addTarget(self, action: #selector(cartBtnAct), for: .touchUpInside)
        cartBtn.frame = CGRect(x: 300, y: 90, width: 45, height: 45)
        return cartBtn
    }()
    
    //Cart Button
    @objc func cartBtnAct(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //func tab Bar action
        setupTabBarText()
        
        
        //nampilin menu dan cart button
        view.addSubview(menuBtn)
        view.addSubview(cartBtn)
        
        //menu button
        let menuBtn = UIBarButtonItem(customView: menuBtn)
        self.navigationItem.leftBarButtonItem  = menuBtn
        
        //cart button
        let cartBtn = UIBarButtonItem(customView: cartBtn)
        self.navigationItem.rightBarButtonItem  = cartBtn
        
        //category collection
        catagoryBrand.dataSource = self
        catagoryBrand.delegate = self
        catagoryBrand.register(CategoryCollectionCell.nib(), forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
        
        //product collection
        productCollectCellView.delegate = self
        productCollectCellView.dataSource = self
        productCollectCellView.collectionViewLayout = UICollectionViewFlowLayout()
        productCollectCellView.register(UINib(nibName: "ProductHomeCollectCell", bundle: nil), forCellWithReuseIdentifier: "ProductHomeCollectCell")
        
        //MARK: BENTUK DARI MENGECEK API DATA JIKA MUNCUL KALAU PAKAI COMPLETION
        //AllCategoryApi().getData { _ in
        //
        //}
        
        AllCategoryApi().getData { [weak self] category in
            self?.catModel.append(contentsOf: category)
            self?.catagoryBrand.reloadData()
        }
        
        //panggil AllProductApi
        AllProductApi().getData { ProductIndex in
            self.productModel.append(contentsOf: ProductIndex)
            self.productCollectCellView.reloadData()
            for product in self.productModel{
                print(product.title)
            }
        }

    }
    
    
}

extension HomepageVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == catagoryBrand {
            return catModel.count
        }
        return productModel.count
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == catagoryBrand {
            return CGSize(width: 150, height: 50 )
        }
        return CGSize(width: 181, height: 358)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == catagoryBrand {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == catagoryBrand {
            guard let catagoryCell =  collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.identifier, for: indexPath) as? CategoryCollectionCell else { return UICollectionViewCell() }
            
            catagoryCell.labelBrand.text = catModel[indexPath.row].capitalized
            return catagoryCell
        } else {
            let cellProduct = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHomeCollectCell", for: indexPath) as! ProductHomeCollectCell
            if searchActive == true {
                cellProduct.configure(data: productFilter[indexPath.item])
            } else {
                cellProduct.configure(data: productModel[indexPath.item])
            }
            return cellProduct
        }
    }
}
