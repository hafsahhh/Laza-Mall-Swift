//
//  CategoryCollectionCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 01/08/23.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    static let identifier = "categoryBrand"
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCollectionCell", bundle: nil)
    }

    @IBOutlet weak var viewContainer: UIView! {
        didSet{
            viewContainer.layer.cornerRadius = CGFloat(15)
        }
    }
    @IBOutlet weak var labelBrand: UILabel!
    @IBOutlet weak var imageBrandView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(data :  brandAllEntry){
        let imgURL = URL(string: "\(data.logo_url)")
        self.imageBrandView.sd_setImage(with: imgURL)
        labelBrand.text = data.name
    }
}
