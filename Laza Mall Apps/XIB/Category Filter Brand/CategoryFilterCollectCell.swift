//
//  CategoryFilterCollectCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 07/08/23.
//

import UIKit

class CategoryFilterCollectCell: UICollectionViewCell {

    static let identifier = "CategoryFilterCollectCell"
    static func nib() -> UINib {
        return UINib(nibName: "CategoryFilterCollectCell", bundle: nil)
    }
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitleView: UILabel!
    @IBOutlet weak var categoryPriceTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

}
