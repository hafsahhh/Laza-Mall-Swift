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
    
    @IBOutlet weak var imageUiviewOutlet: UIImageView!
    {
        didSet{
            imageUiviewOutlet.layer.cornerRadius = imageUiviewOutlet.frame.width / 2
            imageUiviewOutlet.layer.masksToBounds = true
            imageUiviewOutlet.contentMode = .scaleToFill
        }
    }
    @IBOutlet weak var usernameLabelOutlet: UILabel!
    @IBOutlet weak var ratingLabelOutlet: UILabel!
    @IBOutlet weak var reviewLabelOutlet: UILabel!
    @IBOutlet weak var dateLabelOutlet: UILabel!
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
