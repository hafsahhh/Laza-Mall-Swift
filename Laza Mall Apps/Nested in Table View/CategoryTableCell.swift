//
//  CategoryTableCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 01/08/23.
//

import UIKit

protocol categoryTableCellProtocol {
    func showDetailBrand(brand: brandAllEntry)
}


class CategoryTableCell: UITableViewCell {

    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var viewAllBtnOutlet: UIButton!
    @IBOutlet weak var categoryCollectView: UICollectionView!
    
    var modelCat = [brandAllEntry]()
    var reloadTable: (() -> Void)?
    var delegateBrand: categoryTableCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //category collection
        categoryCollectView.dataSource = self
        categoryCollectView.delegate = self
        categoryCollectView.register(CategoryCollectionCell.nib(), forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
        
//        AllCategoryApi().getData { category in
//            guard let catResponses = category else { return }
//            self.modelCat.append(contentsOf: catResponses.data)
//            self.categoryCollectView.reloadData()
//            for category in self.modelCat{
//                print("helo \(category.name)")
//            }
//            self.reloadTable?()
//        }
        
        //panggil AllCategoryApi
        AllCategoryApi().getData { categoryIndex in
            guard let response = categoryIndex else { return }
            self.modelCat.append(contentsOf: response.description)
            self.categoryCollectView.reloadData()
            for product in self.modelCat{
                print("helo \(product.name)")
            }
            self.reloadTable?()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension CategoryTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let catagoryCell =  collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.identifier, for: indexPath) as? CategoryCollectionCell else { return UICollectionViewCell() }
        if indexPath.row < modelCat.count{
              let cellCat = modelCat[indexPath.item]
            catagoryCell.configure(data: cellCat)
          }
        return catagoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(6, modelCat.count)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 50 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateBrand?.showDetailBrand(brand: modelCat[indexPath.item])
    }
}

