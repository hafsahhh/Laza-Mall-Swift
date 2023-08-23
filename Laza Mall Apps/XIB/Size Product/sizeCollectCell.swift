//
//  sizeCollectCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 03/08/23.
//

import UIKit

class sizeCollectCell: UICollectionViewCell {
    
    static let identifier = "sizeCollectCell"
    static func nib() -> UINib {
        return UINib(nibName: "sizeCollectCell", bundle: nil)
    }
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var bgSizeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
