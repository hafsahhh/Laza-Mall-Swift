//
//  CartTableCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 06/08/23.
//

import UIKit

protocol deleteProductInCartProtocol: AnyObject {
    func deleteProductCart(cell: CartTableCell)
}

class CartTableCell: UITableViewCell {
    
    static let identifier = "CartTableCell"
    static func nib() -> UINib {
        return UINib(nibName: "CartTableCell", bundle: nil)
    }
    
    
    @IBOutlet weak var mainCartView: UIView!{
        didSet{
            mainCartView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var cartView: UIView!{
        didSet{
            cartView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var brandProductView: UILabel!
    @IBOutlet weak var imageProductView: UIImageView!
    @IBOutlet weak var titleProductView: UILabel!
    @IBOutlet weak var priceProductView: UILabel!
    @IBOutlet weak var quantityProductView: UILabel!
    @IBOutlet weak var sizeProduct: UILabel!
    @IBOutlet weak var arrowDown: UIButton!{
        didSet{
            arrowDown.layer.cornerRadius = 0.5 * arrowDown.bounds.size.width
            arrowDown.clipsToBounds = true
            arrowDown.layer.borderWidth = 1
            arrowDown.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    @IBOutlet weak var arrowUp: UIButton!{
        didSet {
            arrowUp.layer.cornerRadius = 0.5 * arrowUp.bounds.size.width
            arrowUp.clipsToBounds = true
            arrowUp.layer.borderWidth = 1
            arrowUp.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    @IBOutlet weak var deleteBtnView: UIButton!{
        didSet {
            deleteBtnView.layer.cornerRadius = 0.5 * deleteBtnView.bounds.size.width
            deleteBtnView.clipsToBounds = true
            deleteBtnView.layer.borderWidth = 1
            deleteBtnView.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    func updateQuantityLabel(){
        quantityLabel.text = String(quantityProduct)
    }
    
    var quantityProduct = 0
    weak var delegate: deleteProductInCartProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateQuantityLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func arrowDownBtn(_ sender: Any) {
        if quantityProduct > 0{
            quantityProduct -= 1
        }
        updateQuantityLabel()
    }
    
    
    @IBAction func arrowUpBtn(_ sender: Any) {
        quantityProduct += 1
        updateQuantityLabel()
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        delegate?.deleteProductCart(cell: self)
        print("helo woy")
    }
    
}
