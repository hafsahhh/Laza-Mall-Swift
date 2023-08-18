//
//  ReviewsVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 03/08/23.
//

import UIKit
import Cosmos


class ReviewsVC: UIViewController {

    @IBOutlet weak var userReviewTable: UITableView!
    @IBOutlet weak var reviewRating: CosmosView!
    @IBOutlet weak var emptyDataReview: UILabel!
    
    
    let modelReview =  cellUserReviews()
    var reviewId : Int!
    let reviewViewModel = ReviewViewModel()
    var reviewProduct = [ReviewAllProduct]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //back button
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
        
        reviewAllByProductIdApi()
        
//        //rating
//        reviewRating.rating = 2
//        reviewRating.text = " "
        
        // Register the xib for tableview cell product
        userReviewTable.delegate = self
        userReviewTable.dataSource = self
        userReviewTable.register(UINib(nibName: "ReviewsTableCell", bundle: nil), forCellReuseIdentifier: "ReviewsTableCell")
    }
    
    // MARK: - Navigation
    func reviewAllByProductIdApi() {
        reviewViewModel.getDataReviewProduct(id: reviewId) { [weak self] productDetail in
            DispatchQueue.main.async {
                if let product = productDetail?.data {
                    self?.reviewProduct = product.reviews
                    self?.userReviewTable.reloadData()
                    print("review ada\(product)")
                } else {
                    print("review product data is nil")
                }
            }
        }
    }
    @IBAction func addReviewBtn(_ sender: Any) {
        let addReviewCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddReviewVC") as! AddReviewVC
        self.navigationController?.pushViewController(addReviewCtrl, animated: true)
    }
}

extension ReviewsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviewProduct.count == 0 {
            emptyDataReview.isHidden = false
        } else {
            emptyDataReview.isHidden = true
        }
        return reviewProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableCell", for: indexPath) as? ReviewsTableCell
        else {return UITableViewCell()}
        let review = reviewProduct[indexPath.row]
        let ratingString = String(review.rating)
        cell.usernameView.text = review.fullName.rawValue
        cell.reviewView.text = reviewProduct[indexPath.row].comment
        cell.ratingFromUser.rating = reviewProduct[indexPath.row].rating
        cell.ratingView.text = ratingString
        cell.dateView.text = DateTimeUtils.shared.formatReview(date: review.createdAt)
        // Load the image asynchronously from the URL
        if let imageUrl = URL(string: review.imageURL) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        // Create a UIImage from the loaded image data and assign it to the UIImageView
                        cell.imageUser.image = UIImage(data: imageData)
                    }
                }
            }
        }
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
