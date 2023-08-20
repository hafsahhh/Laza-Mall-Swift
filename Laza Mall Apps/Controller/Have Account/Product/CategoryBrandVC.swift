//
//  CategoryBrandVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 07/08/23.
//

import UIKit

class CategoryBrandVC: UIViewController {
    
    
    @IBOutlet weak var categoryFilterCollectView: UICollectionView!
    
    var brandId : Int = 0
    var modelBrand = [brandEntry]()
    var categoryBrandViewModel = CategoryBrandViewModel()
    
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
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //back button
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
        
        //cell collection
        categoryFilterCollectView.delegate = self
        categoryFilterCollectView.dataSource = self
        categoryFilterCollectView.register(CategoryFilterCollectCell.nib(), forCellWithReuseIdentifier: CategoryFilterCollectCell.identifier)
        
        //get the API
        getBrandProductById()
        
    }
    
    func getBrandProductById() {
        categoryBrandViewModel.getDataBrandProductApi(id: brandId) { brandIndexId in
            guard let response = brandIndexId else { return }
            self.modelBrand.append(response.data) // Append a single BrandEntry object
            DispatchQueue.main.async {
                self.categoryFilterCollectView.reloadData()
            }
        }
    }

}
extension CategoryBrandVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("modelbrand \(modelBrand.count)")
        return modelBrand.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryFilterCollectCell.identifier, for: indexPath) as? CategoryFilterCollectCell {
            productCell.configure(data:modelBrand[indexPath.item])
            return productCell
        }
        return UICollectionViewCell()
    }
    
}
