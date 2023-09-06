//
//  ProductTableCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 01/08/23.
//

import UIKit

protocol productTableCellProtocol {
    func showDetailProduct(product: ProductEntry)
}

class ProductTableCell: UITableViewCell {
    
    static let identifier = "ProductTableCell"
    static func nib() -> UINib {
        return UINib(nibName: "ProductTableCell", bundle: nil)
    }
    
    @IBOutlet weak var newArivallLabel: UILabel!
    @IBOutlet weak var viewAllBtnOutlet: UIButton!
    @IBOutlet weak var productCollectView: UICollectionView!
    
//    var modProduct : ProductResponse?
    var modelProduct = [ProductEntry]()
    var reloadTable: (()->Void)?
    var delegateProductDetail: productTableCellProtocol?
    var searchTextActive: Bool = false
    var filterProduct: [ProductEntry] = []
    var homeViewModel = HomeViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Comment if you set Datasource and delegate in .xib
        productCollectView.dataSource = self
        productCollectView.delegate = self
        productCollectView.register(ProductHomeCollectCell.nib(), forCellWithReuseIdentifier: ProductHomeCollectCell.identifier)
        
        
        //panggil AllProductApi
        homeViewModel.getData { ProductIndex in
            guard let response = ProductIndex else { return }
            self.modelProduct.append(contentsOf: response.data)
            self.productCollectView.reloadData()
            self.reloadTable?()
        }
        
        
        
    }
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //
    //        // Configure the view for the selected state
    //    }
    
    
    @IBAction func viewAllBtn(_ sender: UIButton) {
        if let productAllVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewAllVC") as? ViewAllVC {
            productAllVC.modalPresentationStyle = .fullScreen
            productAllVC.labelProdOrBrand = "Product"
            if let navigationController = self.window?.rootViewController as? UINavigationController {
                navigationController.pushViewController(productAllVC, animated: false)
            }
        }
    }
    
}
extension ProductTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchTextActive == true{
            return filterProduct.count
        } else {
            return min(6, modelProduct.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let productCell =  collectionView.dequeueReusableCell(withReuseIdentifier: ProductHomeCollectCell.identifier, for: indexPath) as? ProductHomeCollectCell {
            if searchTextActive == true {
                _ = filterProduct[indexPath.item]
            } else {
              if indexPath.row < modelProduct.count{
                    let cellFilter = modelProduct[indexPath.item]
                    productCell.configure(data: cellFilter)
                }
            }
            return productCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searchTextActive == true {
            delegateProductDetail?.showDetailProduct(product: modelProduct[indexPath.item])
        } else {
            delegateProductDetail?.showDetailProduct(product: modelProduct[indexPath.item])
        }
    }
    
}

extension ProductTableCell: searchProductHomeProtocol {
    func searchProdFetch(isActive: Bool, textString: String) {
        searchTextActive = isActive
        filterProduct = modelProduct.filter { product in
            return product.name.localizedCaseInsensitiveContains(textString)
        }
        self.productCollectView.reloadData()
    }
}
