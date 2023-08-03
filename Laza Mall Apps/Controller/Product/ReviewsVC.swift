//
//  ReviewsVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 03/08/23.
//

import UIKit

class ReviewsVC: UIViewController {

    @IBOutlet weak var userReviewTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the xib for tableview cell product
        userReviewTable.delegate = self
        userReviewTable.dataSource = self
        userReviewTable.register(UINib(nibName: "ReviewsTableCell", bundle: nil), forCellReuseIdentifier: "ReviewsTableCell")
//        userReviewTable.dataSource = self
//        userReviewTable.delegate = self
//        userReviewTable.register(ReviewsTableCell.nib(), forCellReuseIdentifier: ReviewsTableCell.identifier)
    }
    
    // MARK: - Navigation

}

extension ReviewsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellUserReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableCell", for: indexPath) as? ReviewsTableCell
        else {return UITableViewCell()}
            let cellReviewTable = cellUserReviews [indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
        cell.imageUser.image = cellReviewTable.userImage
        cell.usernameView.text = cellReviewTable.name
        cell.dateView.text = cellReviewTable.time
        cell.ratingView.text = cellReviewTable.rating
        cell.reviewView.text = cellReviewTable.textReviews
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
