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
    
    var modelProduct = [ProductEntry]()
    var reloadTable: (()->Void)?
    var delegateProductDetail: productTableCellProtocol?
    var searchTextActive: Bool = false
    var filterProduct: [ProductEntry] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Comment if you set Datasource and delegate in .xib
        productCollectView.dataSource = self
        productCollectView.delegate = self
        productCollectView.register(ProductHomeCollectCell.nib(), forCellWithReuseIdentifier: ProductHomeCollectCell.identifier)
        
        
        //panggil AllProductApi
        AllProductApi().getData { ProductIndex in
            self.modelProduct.append(contentsOf: ProductIndex)
            self.productCollectView.reloadData()
//            self.delegateProductDetail?.loadApiProd()
            for product in self.modelProduct{
                print("helo \(product.title)")
            }
            self.reloadTable?()
        }
        
    }
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //
    //        // Configure the view for the selected state
    //    }
    
}
extension ProductTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchTextActive == true{
            return filterProduct.count
        } else {
            return modelProduct.count
        }
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
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let productCell =  collectionView.dequeueReusableCell(withReuseIdentifier: ProductHomeCollectCell.identifier, for: indexPath) as? ProductHomeCollectCell {
            if searchTextActive == true {
                _ = filterProduct[indexPath.item]
            } else {
                let cellFilter = modelProduct[indexPath.item]
                productCell.configure(data: cellFilter)
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
        filterProduct = modelProduct.filter{$0.title.contains(textString)}
        self.productCollectView.reloadData()
    }
}
