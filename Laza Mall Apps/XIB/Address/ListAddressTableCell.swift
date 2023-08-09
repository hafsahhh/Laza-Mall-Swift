//
//  ListAddressTableCellTableViewCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 09/08/23.
//

import UIKit

class ListAddressTableCell: UITableViewCell {

    static let identifier = "ListAddressTableCell"
    static func nib() -> UINib {
        return UINib(nibName: "ListAddressTableCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var namePhoneView: UILabel!
    @IBOutlet weak var fullAddressView: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
