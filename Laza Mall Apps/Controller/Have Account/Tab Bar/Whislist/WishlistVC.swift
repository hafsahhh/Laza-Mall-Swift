//
//  WishlistVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 31/07/23.
//

import UIKit
protocol wihslistShowDetailProtocol {
    func wishlistShowDetailProduct(product: ProductEntry)
}

class WishlistVC: UIViewController {
    
    
    @IBOutlet weak var wishlistCollectView: UICollectionView!
    @IBOutlet weak var emptyDataWishlist: UILabel!
    @IBOutlet weak var totalWishlist: UILabel!
    
    var modelWhishlist: WishlistProductIndex?
    var wishlistViewModel = WishlistViewModel()
    //show detail produst using protocol
    var delegateWishlistProduct: wihslistShowDetailProtocol?
    
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
        wishlistCollectView.register(ProductHomeCollectCell.nib(), forCellWithReuseIdentifier: ProductHomeCollectCell.identifier)
        
        getUserWishlist()
        wishlistCollectView.reloadData()
    }
    
    func getUserWishlist() {
        wishlistViewModel.getWishlistUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userWishlist):
                    self.modelWhishlist = userWishlist
                    self.totalWishlist.text = "\(userWishlist.data?.total ?? 0)" // Menggunakan optional chaining dan nil coalescing
                    self.wishlistCollectView.reloadData()
                case .failure(let error):
                    // Tangani error dengan sesuai
                    print("Error fetching user wishlist: \(error)")
                }
            }
        }
    }
    
}




extension WishlistVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("model wislist\(String(describing: modelWhishlist??.data?.products.count))")
        if modelWhishlist??.data?.products.count == 0 {
            emptyDataWishlist.isHidden = false
        } else {
            emptyDataWishlist.isHidden = true
        }
        return modelWhishlist??.data?.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let wishlistCell =  collectionView.dequeueReusableCell(withReuseIdentifier: ProductHomeCollectCell.identifier, for: indexPath) as? ProductHomeCollectCell
        else {
            return UICollectionViewCell()
        }
        if let cellWishlist = modelWhishlist??.data?.products[indexPath.row] {
            wishlistCell.imageView.setImageWithPlugin(url: cellWishlist.imageURL)
            wishlistCell.titleView.text = cellWishlist.name
            wishlistCell.priceView.text = String(cellWishlist.price)
        }
        return wishlistCell
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
            detailViewController.productId =  modelWhishlist??.data?.products[indexPath.item].id
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
