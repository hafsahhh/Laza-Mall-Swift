//
//  ProductHomeCollectCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 27/07/23.
//

import UIKit
import SDWebImage

class ProductHomeCollectCell: UICollectionViewCell {
    
    static let identifier = "ProductHomeCollectCell"
    static func nib() -> UINib {
        return UINib(nibName: "ProductHomeCollectCell", bundle: nil)
    }
    
    @IBOutlet weak var productView: UIView!{
        didSet{
            productView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var priceView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data :  ProductEntry){
        let imgURL = URL(string: "\(data.imageURL)")
        self.imageView.sd_setImage(with: imgURL)
        titleView.text = data.name
        priceView.text = String("$ \(data.price)")
    }
    
    func configureWishlist(data: ProductWishlistEntry){
        let imgURL = URL(string: "\(data.imageURL)")
        self.imageView.sd_setImage(with: imgURL)
        titleView.text = data.name
        priceView.text = String("$ \(data.price)")
    }
}
