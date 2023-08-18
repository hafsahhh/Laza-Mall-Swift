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
    var whishlistModel: [likeProductWhishlist] = []
    
    
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
        likeBtn.setImage(UIImage(named:"Whislist-Menu"), for: .normal)
        likeBtn.addTarget(self, action: #selector(likeBtnAct), for: .touchUpInside)
        likeBtn.frame = CGRect(x: 330, y: 0, width: 45, height: 45)
        return likeBtn
    }()
    
    
    //Like Button
    @objc func likeBtnAct(){
        guard let imageProduct = self.product?.imageURL else {return}
        guard let titleProduct = self.product?.name else {return}
        guard let priceProduct = self.product?.price else {return}
        
        let newLikedProduct = likeProductWhishlist(imageWhishlistProd: imageProduct, titleWhishlistProd: titleProduct, priceWhislistProd: Int16(Int(priceProduct)))
        
        // Pastikan produk belum ada di dalam daftar sebelum menambahkannya
        if !whishlistModel.contains(newLikedProduct) {
            whishlistModel.append(newLikedProduct)
            
            // Ubah array menjadi Data dan simpan ke UserDefaults
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(whishlistModel)
                UserDefaults.standard.set(data, forKey: "whishlistModelKey")
                print("Wishlist tersimpan \(whishlistModel)")
            } catch {
                print("Terjadi kesalahan saat menyimpan data: \(error)")
            }
        }
        
        // Update tampilan tombol 'Like' (jika diperlukan)
        likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
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
        
    }
    
    
    
    func detailProductApi() {
        detailProductViewModel.getDataDetailProduct(id: productId) { [weak self] productDetail in
            DispatchQueue.main.async {
                if let product = productDetail?.data {
                    self?.sizeProduct.append(contentsOf: product.size)
                    self?.reviewProduct.append(contentsOf: product.reviews)
                    self?.catTitleView.text = product.name
                    self?.priceView.text = String("$ \(product.price)")
                    self?.descView.text = product.description
                    self?.catBrandView.text = product.category.category
                    if let imageUrl = URL(string: product.imageURL){
                        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self?.imageProView.image = image
                                }
                            }
                        }.resume()
                    }
                    if let rating = self?.reviewProduct.first?.rating {
                        self?.ratingProView.rating = rating
                        self?.ratingUserReview.text = String(rating)
                    }
                    if let review =  self?.reviewProduct.first {
                        self?.reviewView.text = review.comment
                        self?.usernameReviewerView.text = review.fullName
                        self?.dateReviewView.text = DateTimeUtils.shared.formatReview(date: review.createdAt)
                        if let imageUrl = URL(string: review.imageURL){
                            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                                if let data = data, let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self?.imageReviewView.image = image
                                    }
                                }
                            }.resume()
                        }
                    }
                    
                    self?.sizeCollectView.reloadData()
                } else {
                    print("productDetail data is nil")
                }
            }
        }
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
