//
//  WishlistVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 31/07/23.
//

import UIKit

class WishlistVC: UIViewController {
    
    
    @IBOutlet weak var wishlistCollectView: UICollectionView!
    @IBOutlet weak var emptyDataWishlist: UILabel!
    
    
    let modelWhishlist = indexWishlist()
    
    //tab bar wishlist
    private func setupTabBarText() {
        let label2 = UILabel()
        label2.numberOfLines = 1
        label2.textAlignment = .center
        label2.text = "Whishlist"
        label2.font = UIFont(name: "inter-Medium", size: 11)
        label2.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "colorBg")
        tabBarItem.selectedImage = UIImage(view: label2)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //func tab Bar action
        setupTabBarText()
        
        self.wishlistCollectView.dataSource = self
        self.wishlistCollectView.delegate = self
        wishlistCollectView.register(WishlistCollectCell.nib(), forCellWithReuseIdentifier: WishlistCollectCell.identifier)
        wishlistCollectView.reloadData()
    }
    
}
extension WishlistVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if modelWhishlist.count == 0{
            emptyDataWishlist.isHidden = false
        } else {
            emptyDataWishlist.isHidden = true
        }
        return modelWhishlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let wishlistCell =  collectionView.dequeueReusableCell(withReuseIdentifier: WishlistCollectCell.identifier, for: indexPath) as? WishlistCollectCell
        else {
            return UICollectionViewCell()
        }
        return wishlistCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
