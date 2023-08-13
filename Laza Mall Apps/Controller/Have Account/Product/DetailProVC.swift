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
    @IBOutlet weak var reviewView: UILabel!
    @IBOutlet weak var ratingProView: CosmosView!
    
    
    var product: ProductEntry?
    let sizeDummy = ["S", "L", "XL", "2XL", "3XL"]
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
        likeBtn.setImage(UIImage(named:"Heart"), for: .normal)
        likeBtn.addTarget(self, action: #selector(likeBtnAct), for: .touchUpInside)
        likeBtn.frame = CGRect(x: 330, y: 0, width: 45, height: 45)
        return likeBtn
    }()
    
    
    //Like Button
    @objc func likeBtnAct(){
        guard let imageProduct = self.product?.image else {return}
        guard let titleProduct = self.product?.title else {return}
        guard let priceProduct = self.product?.price else {return}
        
        let newLikedProduct = likeProductWhishlist(imageWhishlistProd: imageProduct, titleWhishlistProd: titleProduct, priceWhislistProd: Int16(priceProduct))
        
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
        
        
        loadDetail()
        //category collection
        sizeCollectView.dataSource = self
        sizeCollectView.delegate = self
        sizeCollectView.register(sizeCollectCell.nib(), forCellWithReuseIdentifier: sizeCollectCell.identifier)
        
        //rating
        ratingProView.rating = 2
        ratingProView.text = " "
    }
    

    // MARK: - UI with API
    func loadDetail(){
        if let detailProduct = product {
            catTitleView.text = detailProduct.title
            catBrandView.text = detailProduct.category.rawValue
            priceView.text = String("$ \(detailProduct.price)")
            descView.text = detailProduct.description
            
            if let imageUrl = URL(string: detailProduct.image){
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageProView.image = image
                        }
                    }
                }.resume()
                
            }
        }
    }
    
    @IBAction func reviewViewAll(_ sender: Any) {
        let reviewViewAllBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
        self.navigationController?.pushViewController(reviewViewAllBtn, animated: true)
    }
    
}
// MARK: - extension
extension DetailProVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sizeDummy.count
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
        
        sizeCell.sizeLabel.text = sizeDummy[indexPath.row]
        return sizeCell
    }
    
    
}
