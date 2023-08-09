//
//  ListAddressCellTable.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 09/08/23.
//

import UIKit

class ListAddressCellTable: UITableViewCell {
    static let identifier = "ListAddressCellTable"
    static func nib() -> UINib {
        return UINib(nibName: "ListAddressCellTable", bundle: nil)
    }
    
    @IBOutlet weak var nameAddressView: UILabel!
    @IBOutlet weak var fullAddressView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
