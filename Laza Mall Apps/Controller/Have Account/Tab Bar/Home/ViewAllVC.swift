//
//  ViewAllVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 23/08/23.
//

import UIKit

class ViewAllVC: UIViewController {
    
    
    @IBOutlet weak var labelProdOrBrandView: UILabel!
    @IBOutlet weak var viewAllCollect: UICollectionView!
    
    var labelProdOrBrand: String = ""
    var modelBrand = [brandAllEntry]()
    var modelProduct = [ProductEntry]()
    var viewAllModelView = HomeViewModel()
    
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
        
        viewAllCollect.dataSource = self
        viewAllCollect.delegate = self
        labelProdOrBrandView.text = labelProdOrBrand
        viewAll()
    }
    
    func viewAll() {
        if labelProdOrBrand != "Brand" {
            self.viewAllCollect.register(ProductHomeCollectCell.nib(), forCellWithReuseIdentifier: ProductHomeCollectCell.identifier)
            viewAllModelView.getData { ProductIndex in
                guard let response = ProductIndex else { return }
                self.modelProduct.append(contentsOf: response.data)
                self.viewAllCollect.reloadData()
            }
        } else {
            self.viewAllCollect.register(CategoryCollectionCell.nib(), forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
            viewAllModelView.getBrandAllData { categoryIndex in
                guard let response = categoryIndex else { return }
                self.modelBrand.append(contentsOf: response.description)
                self.viewAllCollect.reloadData()
            }
        }
    }
}
// MARK: - Extensions
extension ViewAllVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if labelProdOrBrand == "Brand" {
            return modelBrand.count
        } else {
            return modelProduct.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if labelProdOrBrand == "Brand" {
            guard let catagoryCell =  collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.identifier, for: indexPath) as? CategoryCollectionCell else { return UICollectionViewCell() }
            if indexPath.row < modelBrand.count{
                let cellCat = modelBrand[indexPath.item]
                catagoryCell.configure(data: cellCat)
            }
            return catagoryCell
        } else {
            guard let productCell =  collectionView.dequeueReusableCell(withReuseIdentifier: ProductHomeCollectCell.identifier, for: indexPath) as? ProductHomeCollectCell else { return UICollectionViewCell() }
            if indexPath.row < modelProduct.count{
                let cellProd = modelProduct[indexPath.item]
                productCell.configure(data: cellProd)
            }
            return productCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if labelProdOrBrand == "Brand" {
            return CGSize(width: 170, height: 100)
        } else {
            return CGSize(width: 151, height: 328)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if labelProdOrBrand == "Brand" {
            return 5
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if labelProdOrBrand == "Brand" {
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if labelProdOrBrand == "Brand" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailBrand = storyboard.instantiateViewController(withIdentifier: "CategoryBrandVC") as! CategoryBrandVC
            detailBrand.brandName = modelBrand[indexPath.item].name
            self.navigationController?.pushViewController(detailBrand , animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailProVC") as! DetailProVC
            detailVC.productId = modelProduct[indexPath.item].id
            self.navigationController?.pushViewController(detailVC , animated: true)
        }
        
    }
    
    
    
    
}
