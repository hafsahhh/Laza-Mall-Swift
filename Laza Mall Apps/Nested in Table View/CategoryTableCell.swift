//
//  CategoryTableCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 01/08/23.
//

import UIKit



class CategoryTableCell: UITableViewCell {

    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var viewAllBtnOutlet: UIButton!
    @IBOutlet weak var categoryCollectView: UICollectionView!
    
    var modelCat = categoryIndex()
    var reloadTable: (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        //category collection
        categoryCollectView.dataSource = self
        categoryCollectView.delegate = self
        categoryCollectView.register(CategoryCollectionCell.nib(), forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
        
        AllCategoryApi().getData { [weak self] category in
            self?.modelCat.append(contentsOf: category)
            self?.categoryCollectView.reloadData()
            self?.reloadTable?()
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
        
        catagoryCell.labelBrand.text = modelCat[indexPath.row].capitalized
        print("data yang ini",modelCat[indexPath.row].capitalized)
        return catagoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelCat.count
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
}
