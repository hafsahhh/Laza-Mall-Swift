//
//  ProductHomeCollectCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 27/07/23.
//

import UIKit
import SDWebImage

class ProductHomeCollectCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var loveView: UIButton!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var priceView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data :  ProductEntry){
        let imgURL = URL(string: "\(data.image)")
        self.imageView.sd_setImage(with: imgURL)
        titleView.text = data.title
        priceView.text = String("$ \(data.price)")
    }

}
