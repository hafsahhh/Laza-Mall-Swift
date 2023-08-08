//
//  WishlistVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 31/07/23.
//

import UIKit

class WishlistVC: UIViewController {
    
    
    @IBOutlet weak var wishlistCollectView: UICollectionView!
    
    
//    var whishlistModel: [likeProductWhishlist] = []
    
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
        
//        loadDataFromUserDefaults()
        wishlistCollectView.reloadData()
    }
    
//    // Function to load data from UserDefaults to whishlistModel
//    private func loadDataFromUserDefaults() {
//        if let savedData = UserDefaults.standard.data(forKey: "whishlistModelKey") {
//            let decoder = JSONDecoder()
//            if let savedWhishlistModel = try? decoder.decode([likeProductWhishlist].self, from: savedData) {
//                whishlistModel = savedWhishlistModel
//                print("Wishlist loaded from UserDefaults: \(whishlistModel)")
//            }
//        }
//    }


    
}
extension WishlistVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("whislist model  \(whishlistModel.count)")
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let wishlistCell =  collectionView.dequeueReusableCell(withReuseIdentifier: WishlistCollectCell.identifier, for: indexPath) as? WishlistCollectCell
        else {
            return UICollectionViewCell()
        }
        
        
//        let wishlistProduct = whishlistModel [indexPath.row]
//
//        // Muatan URL secara asinkron menggunakan URLSession
//        if let urlGambar = URL(string: wishlistProduct.imageWhishlistProd) {
//            URLSession.shared.dataTask(with: urlGambar) { (data, response, error) in
//                if let dataGambar = data {
//                    DispatchQueue.main.async {
//                        wishlistCell.productWhishlistView.image = UIImage(data: dataGambar)
//                    }
//                }
//            }.resume()
//        }
//        wishlistCell.titleWhishlistView.text = wishlistProduct.titleWhishlistProd
//        wishlistCell.priceWhislistView.text = String("$ \(wishlistProduct.priceWhislistProd)")
        return wishlistCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
