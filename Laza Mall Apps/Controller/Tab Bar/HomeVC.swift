//
//  HomeVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 26/07/23.
//

import UIKit

class HomeVC: UIViewController {
    
    //    var apiResult = [ProductIndex(results: [ProductEntry]())]
    //    var apiResultCat = [categoryIndex(results: [categoryEntry]())]
    var categoryModel = [categoryEntry]()
    let allCategoryApi = AllCategoryApi()
    var productModel = [ProductEntry]()
    
    var categoryMod: categoryIndex?
    var productFilter: [ProductEntry] = []
    //    var productSelected: ProductEntry?
    //    var categorySelected: categoryEntry?
    var searchActive : Bool = false
    
    
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var categoryCollectView: UICollectionView!
    @IBOutlet weak var productCollectView: UICollectionView!
    
    //Menu Button
    private lazy var menuBtn : UIButton = {
        //call back button
        let menuBtn = UIButton.init(type: .custom)
        menuBtn.setImage(UIImage(named:"Menu"), for: .normal)
        menuBtn.addTarget(self, action: #selector(menuBtnAct), for: .touchUpInside)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        return menuBtn
    }()
    
    //Menu Button
    @objc func menuBtnAct(){
        
    }
    
    //Cart Button
    private lazy var cartBtn : UIButton = {
        //call back button
        let cartBtn = UIButton.init(type: .custom)
        cartBtn.setImage(UIImage(named:"Cart"), for: .normal)
        cartBtn.addTarget(self, action: #selector(cartBtnAct), for: .touchUpInside)
        cartBtn.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        return cartBtn
    }()
    
    //Cart Button
    @objc func cartBtnAct(){
        
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //menu button
        let menuBtn = UIBarButtonItem(customView: menuBtn)
        self.navigationItem.leftBarButtonItem  = menuBtn
        
        //cart button
        let cartBtn = UIBarButtonItem(customView: cartBtn)
        self.navigationItem.rightBarButtonItem  = cartBtn
        
        
        //product collection
        productCollectView.delegate = self
        productCollectView.dataSource = self
        productCollectView.collectionViewLayout = UICollectionViewFlowLayout()
        productCollectView.register(UINib(nibName: "ProductHomeCollectCell", bundle: nil), forCellWithReuseIdentifier: "ProductHomeCollectCell")
        
        //category collection
        categoryCollectView.dataSource = self
        categoryCollectView.delegate = self
        categoryCollectView.collectionViewLayout = UICollectionViewLayout()
        categoryCollectView.register(UINib(nibName : "CategoryCollectCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectCell")
        
        
        //panggil AllProductApi
        AllProductApi().getData { ProductIndex in
            self.productModel.append(contentsOf: ProductIndex)
            self.productCollectView.reloadData()
            for product in self.productModel{
                print(product.title)
            }
        }
        
        //panggil allCategoryApi
        allCategoryApi.getData { categoryIndex in
            // Update the categoryModel with the fetched data
            self.categoryModel = categoryIndex.map { categoryName in
                guard let category = Category(rawValue: categoryName) else {
                    return nil // Skip invalid data
                }
                return categoryEntry(category: category)
            }.compactMap { $0 }
            
            // Reload the categoryCollectView to display the updated data
            self.categoryCollectView.reloadData()
            
            print("Categories: \(categoryIndex)")
            // Rest of the code
        }

        
//        allCategoryApi.getData { categoryIndex in
//            self.categoryCollectView.reloadData()
//            print("Categories: \(categoryIndex)")
//            self.categoryModel = categoryIndex.compactMap { categoryName in
//                guard let category = Category(rawValue: categoryName) else {
//                    return nil // Skip invalid data
//                }
//                return categoryEntry(category: category)
//
//            }
//        }
        //        allCategoryApi.getData { categoryList in
        //            DispatchQueue.main.async {
        //                self.categoryCollectView.reloadData()
        //                for _ in self.categoryModel{
        //                    print(categoryList)
        //                }
        //            }
        //        }
        
    }
}



extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.productCollectView {
            if searchActive == true {
                return productFilter.count
            } else {
                return productModel.count
            }
        }else if collectionView == categoryCollectView {
            return categoryModel.count
        }
        return 0
        
        //        if searchActive == true {
        //            return productFilter.count
        //        } else {
        //            return productModel.count
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.productCollectView {
            return CGSize(width: 181, height: 358)
        }
        return CGSize(width: 80, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.productCollectView {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.productCollectView {
            let cellProduct = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHomeCollectCell", for: indexPath) as! ProductHomeCollectCell
            if searchActive == true {
                cellProduct.configure(data: productFilter[indexPath.item])
            } else {
                cellProduct.configure(data: productModel[indexPath.item])
            }
            return cellProduct
        } else {
            let cellCat = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectCell", for: indexPath) as! CategoryCollectCell
            cellCat.configureCategory(data: categoryModel[indexPath.item])
            return cellCat
        }
    }

//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == self.productCollectView {
//            let cellProduct = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHomeCollectCell", for: indexPath) as! ProductHomeCollectCell
//            if searchActive == true {
//                cellProduct.configure(data: productFilter[indexPath.item])
//            } else {
//                cellProduct.configure(data: productModel[indexPath.item])
//            }
//            return cellProduct
//        }
//
//        else {
//            let cellCat = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectCell", for: indexPath) as! CategoryCollectCell
//            cellCat.configureCategory(data: categoryModel[indexPath.item])
//            return cellCat
//        }
//    }
}


//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHomeCollectCell", for: indexPath) as! ProductHomeCollectCell
//        if searchActive == true {
//            cell.configure(data: productFilter[indexPath.item])
//        } else {
//            cell.configure(data: productModel[indexPath.item])
//        }
//        cell.shadowDecorate()
//        return cell
