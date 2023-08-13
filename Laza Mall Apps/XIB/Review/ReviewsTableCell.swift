//
//  ReviewsTableCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 03/08/23.
//

import UIKit
import Cosmos

class ReviewsTableCell: UITableViewCell {
    
    static let identifier = "ReviewsTableCell"
    static func nib() -> UINib {
        return UINib(nibName: "ReviewsTableCell", bundle: nil)
    }
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var usernameView: UILabel!
    @IBOutlet weak var ratingView: UILabel!
    @IBOutlet weak var reviewView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var ratingFromUser: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ratingFromUser.rating = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
