//
//  DetailProVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 02/08/23.
//

import UIKit
import Cosmos

class DetailProVC: UIViewController {
    
    
    @IBOutlet weak var imageProView: UIImageView!
    @IBOutlet weak var catBrandView: UILabel!
    @IBOutlet weak var catTitleView: UILabel!
    @IBOutlet weak var priceView: UILabel!
    @IBOutlet weak var sizeCollectView: UICollectionView!
    @IBOutlet weak var descView: UILabel!
    @IBOutlet weak var usernameReviewerView: UILabel!
    @IBOutlet weak var reviewView: UILabel!
    @IBOutlet weak var dateReviewView: UILabel!
    @IBOutlet weak var ratingProView: CosmosView!
    @IBOutlet weak var imageReviewView: UIImageView!
    @IBOutlet weak var ratingUserReview: UILabel!
    
    
    var product: ProductEntry?
    var productDetail: DataDetailProduct?
    var productId : Int!
    var detailProductViewModel = DetailProductViewModel()
    var sizeProduct = [Size]()
    var reviewProduct = [Review]()
    var modelUpdateWishlist: UpdateWishlist?
    var whishlistModel: [WishlistProductIndex] = []
    var wishlistViewModel = WishlistViewModel()
    var imageName: String = ""
    
    
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
    
    //like Button
    private lazy var likeBtn : UIButton = {
        //call back button
        let likeBtn = UIButton.init(type: .custom)
        likeBtn.tintColor = .black
        likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        likeBtn.addTarget(self, action: #selector(likeBtnAct), for: .touchUpInside)
        likeBtn.frame = CGRect(x: 330, y: 0, width: 70, height: 70)
        return likeBtn
    }()
    
    //like objc
    @objc func likeBtnAct(){
        updateWishlist()
    }
    
    func isProductInWishlists(productId: Int, completion: @escaping (Bool) -> Void) {
        wishlistViewModel.getWishlistUser { result in
            switch result {
            case .success(let wishlistIndex):
                if let products = wishlistIndex.data?.products {
                    let isInWishlist = products.contains { product in
                        return product.id == productId
                    }
                    completion(isInWishlist)
                } else {
                    completion(false) // No wishlist data available
                }
            case .failure:
                completion(false) // Error fetching wishlist data
            }
        }
    }
    
    
    func updateWishlist(){
        detailProductViewModel.putWishlistUser(productId: productId) { result in
            var message: String = "" // Inisialisasi pesan di sini
            
            switch result {
            case .success:
                self.detailProductViewModel.apiAlertDetailProduct = { status, data in
                    DispatchQueue.main.async {
                        print(data)
                        if data.contains("added") {
                            self.imageName = "heart.fill"
                        } else {
                            self.imageName = "heart"
                        }
                        
                        // Update the button image
                        let image = UIImage(systemName: self.imageName)
                        self.likeBtn.setImage(image, for: .normal) // Update the button image here
                        message = data // Menangkap pesan di sini
                        ShowAlert.addReview(on: self, title: status, message: message)
                    }
                }
            case .failure(let error):
                self.detailProductViewModel.apiAlertDetailProduct = { status, data in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                        message = data // Menangkap pesan di sini
                        ShowAlert.addReview(on: self, title: status, message: data)
                    }
                }
                print("API update wishlist Error: \(error)")
            }
        }
    }
    
    
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //back button
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
        //cart button
        let likeBtn = UIBarButtonItem(customView: likeBtn)
        self.navigationItem.rightBarButtonItem  = likeBtn
        
        detailProductApi()
        
        //category collection
        sizeCollectView.dataSource = self
        sizeCollectView.delegate = self
        sizeCollectView.register(sizeCollectCell.nib(), forCellWithReuseIdentifier: sizeCollectCell.identifier)
        
        
        isProductInWishlists(productId: productId) { isInWishlist in
            if isInWishlist {
                self.imageName = "heart.fill"
            } else {
                self.imageName = "heart"
            }
            DispatchQueue.main.async {
                // Update the button image
                let image = UIImage(systemName: self.imageName)
                self.likeBtn.setImage(image, for: .normal)
            }
        }
        
    }
    
    func detailProductApi() {
        detailProductViewModel.getDataDetailProduct(id: productId) { [weak self] productDetail in
            DispatchQueue.main.async {
                guard let product = productDetail?.data else {
                    print("productDetail data is nil")
                    return
                }
                
                self?.sizeProduct.append(contentsOf: product.size)
                self?.reviewProduct.append(contentsOf: product.reviews)
                self?.catTitleView.text = product.name
                self?.priceView.text = String("$ \(product.price)")
                self?.descView.text = product.description
                self?.catBrandView.text = product.category.category
                
                if let imageUrl = URL(string: product.imageURL) {
                    URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                        guard let data = data, let image = UIImage(data: data) else {
                            return
                        }
                        DispatchQueue.main.async {
                            self?.imageProView.image = image
                        }
                    }.resume()
                }
                
                if let rating = self?.reviewProduct.first?.rating {
                    self?.ratingProView.rating = rating
                    self?.ratingUserReview.text = String(rating)
                }
                
                if let review = self?.reviewProduct.first {
                    self?.reviewView.text = review.comment
                    self?.usernameReviewerView.text = review.fullName
                    self?.dateReviewView.text = DateTimeUtils.shared.formatReview(date: review.createdAt)
                    
                    if let imageUrl = URL(string: review.imageURL) {
                        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                            guard let data = data, let image = UIImage(data: data) else {
                                return
                            }
                            DispatchQueue.main.async {
                                self?.imageReviewView.image = image
                            }
                        }.resume()
                    }
                }
                
                self?.sizeCollectView.reloadData()
            }
        }
    }
    
    
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        let imageName = sender.isSelected ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        sender.setImage(image, for: .normal)
        
        // You can also update the wishlist status here based on the `sender.isSelected` value
        // For example, you can call a function to update the wishlist status in the ViewModel.
        // wishlistViewModel.updateWishlistStatus(isWishlisted: sender.isSelected)
    }
    
    
    
    @IBAction func reviewViewAll(_ sender: Any) {
        let reviewViewAllBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
        reviewViewAllBtn.reviewId = productId
        self.navigationController?.pushViewController(reviewViewAllBtn, animated: true)
    }
    
}
// MARK: - extension
extension DetailProVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("size product\(sizeProduct)")
        return sizeProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 60 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sizeCell =  collectionView.dequeueReusableCell(withReuseIdentifier: sizeCollectCell.identifier, for: indexPath) as? sizeCollectCell else { return UICollectionViewCell() }
        
        sizeCell.sizeLabel.text = sizeProduct[indexPath.row].size
        return sizeCell
    }
    
    
}
