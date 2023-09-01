//
//  DetailProVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 02/08/23.
//

import UIKit
import Cosmos
import JWTDecode

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
    var idSizeProductSelected: Int!
    var selectedSizeIndexPath: IndexPath?
    var isValidToken = false
    
    
    // MARK: - Button back using programmaticly
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
    
    // MARK: - Button Like using programmaticly
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
    
    // MARK: - Func for button like stay in filled button
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
    
    // MARK: - Func Update Wishlist
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
    
    func addCarts(){
        guard let idSize = self.idSizeProductSelected else {
            print("id for size is nil")
            self.alertShowApi(title: "Sorry!", message: "Please choose your size product")
            return
        }
        detailProductViewModel.addCarts(idProduct: productId, idSize: idSize) { result in
            print("inii carts\(String(describing: self.productId))")
            switch result {
            case . success(let data):
                DispatchQueue.main.async {
                    ShowAlert.performAlertApi(on: self, title: "Carts Notification", message: "Successfully Add New Product to Cart")
                }
                print("API Response Data Carts: \(String(describing: data))")
            case .failure(let error):
                self.detailProductViewModel.apiAlertDetailProduct = { status, data in
                    DispatchQueue.main.async {
                        ShowAlert.performAlertApi(on: self, title: status, message: data)
                    }
                }
                print("API add to carts Error: \(error.localizedDescription)")
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
        callCollectView()
        
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

    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func callCollectView(){
        //category collection
        sizeCollectView.dataSource = self
        sizeCollectView.delegate = self
        sizeCollectView.register(sizeCollectCell.nib(), forCellWithReuseIdentifier: sizeCollectCell.identifier)
    }
    // MARK: - Func Detail Product
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
    

    
    // MARK: - Review All
    @IBAction func reviewViewAll(_ sender: Any) {
        let reviewViewAllBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
        reviewViewAllBtn.reviewId = productId
        self.navigationController?.pushViewController(reviewViewAllBtn, animated: true)
    }
    
    
    @IBAction func addToCartBtn(_ sender: UIButton) {
        addCarts()
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
        if indexPath == selectedSizeIndexPath {
            sizeCell.bgSizeView.backgroundColor = UIColor(named: "ColorBg")
            sizeCell.sizeLabel.textColor = UIColor(named: "ColorWhite")
        } else {
            sizeCell.bgSizeView.backgroundColor = UIColor(named: "colorbrand")
            sizeCell.sizeLabel.textColor = UIColor(named: "ColorBlack")
        }
        return sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSizeIndexPath = indexPath
        let selectedProduct = sizeProduct[indexPath.row]
        
        self.idSizeProductSelected = selectedProduct.id
        print("Index Id Size", String(idSizeProductSelected!))
        collectionView.reloadData()
    }
}
