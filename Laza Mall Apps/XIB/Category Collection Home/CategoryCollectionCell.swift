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
            viewContainer.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var labelBrand: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(data :  categoryEntry){
        labelBrand.text = data.name
    }
}
