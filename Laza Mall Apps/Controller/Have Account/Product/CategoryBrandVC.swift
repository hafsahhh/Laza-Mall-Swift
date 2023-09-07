//
//  CategoryBrandVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 07/08/23.
//

import UIKit

class CategoryBrandVC: UIViewController {
    
    @IBOutlet weak var brandNameView: UILabel!
    @IBOutlet weak var categoryFilterCollectView: UICollectionView!
    @IBOutlet weak var totalItems: UILabel!
    @IBOutlet weak var sortItemView: UIButton!{
        didSet{
            sortItemView.setImage(UIImage(systemName: " "), for: .normal)
            sortItemView.setTitle("Sort", for: .normal)
        }
    }
    @IBOutlet weak var emptyProductLabel: UILabel!
    
    
    //    var brandId : Int = 0
    var brandName: String = ""
    var modelBrand = [prodByIdBrandEntry]()
    var categoryBrandViewModel = CategoryBrandViewModel()
    var ascSort = true
    
    
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
        sortProduct()
        
    }
    
    func getBrandProductById() {
        
        categoryBrandViewModel.getDataBrandProductApi(name: brandName) { response in
            let name = self.brandName
            self.brandNameView.text = name.uppercased()
            print(name)
            DispatchQueue.main.async {
                if let responseData = response?.data {
                    self.modelBrand.append(contentsOf: responseData)
                    self.totalItems.text = "\(responseData.count)" // Display total count of items
                    self.categoryFilterCollectView.reloadData()
                } else {
                    print("Response data is nil")
                }
            }
        }
    }
    
    func sortProduct(){
        ascSort.toggle()
        sortProData()
    }
    func sortProData(){
        if sortItemView.currentImage == UIImage(systemName: ""){
            sortItemView.setTitle("Sort", for: .normal)
            sortItemView.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        }else if ascSort {
            modelBrand.sort { $0.name < $1.name }
            sortItemView.setTitle("A-Z", for: .normal)
            sortItemView.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        } else if !ascSort {
            modelBrand.sort { $0.name > $1.name }
            sortItemView.setTitle("Z-A", for: .normal)
            sortItemView.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        }
        categoryFilterCollectView.reloadData()
    }
    
    
    @IBAction func sortActBtn(_ sender: Any) {
        sortProduct()
    }
    
    
}

extension CategoryBrandVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if modelBrand.count == 0 {
            emptyProductLabel.isHidden = false
        } else {
            emptyProductLabel.isHidden = true
        }
        return modelBrand.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailProVC") as? DetailProVC {
            detailViewController.productId = modelBrand[indexPath.item].id
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryFilterCollectCell.identifier, for: indexPath) as? CategoryFilterCollectCell {
            productCell.configure(data:modelBrand[indexPath.item])
            return productCell
        }
        return UICollectionViewCell()
    }
    
}
