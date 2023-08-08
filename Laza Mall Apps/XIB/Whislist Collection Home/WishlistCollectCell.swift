//
//  WishlistCollectCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 06/08/23.
//

import UIKit

class WishlistCollectCell: UICollectionViewCell {
    
    static let identifier = "WishlistCollectCell"
    static func nib() -> UINib {
        return UINib(nibName: "WishlistCollectCell", bundle: nil)
    }
    
    @IBOutlet weak var productWhishlistView: UIImageView!
    @IBOutlet weak var titleWhishlistView: UILabel!
    @IBOutlet weak var priceWhislistView: UILabel!
    
    var whishlistModel: [likeProductWhishlist] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
