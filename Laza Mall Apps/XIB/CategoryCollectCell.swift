//
//  CategoryCollectCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 27/07/23.
//

import UIKit

class CategoryCollectCell: UICollectionViewCell {

    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCategory(data :  categoryEntry){
        categoryLabel.text = data.category.rawValue
    }
}
