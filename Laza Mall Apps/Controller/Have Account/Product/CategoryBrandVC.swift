//
//  CategoryBrandVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 07/08/23.
//

import UIKit

class CategoryBrandVC: UIViewController {
    
    
    @IBOutlet weak var categoryFilterCollectView: UICollectionView!
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryFilterCollectView.delegate = self
        categoryFilterCollectView.dataSource = self
        categoryFilterCollectView.register(CategoryFilterCollectCell.nib(), forCellWithReuseIdentifier: CategoryFilterCollectCell.identifier)
        
    }

}

extension CategoryBrandVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let catFilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryFilterCollectCell.identifier, for: indexPath) as? CategoryFilterCollectCell
        else {
            return UICollectionViewCell()
        }
        return catFilterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
