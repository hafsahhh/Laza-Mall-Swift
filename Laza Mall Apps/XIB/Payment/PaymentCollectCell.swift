//
//  PaymentCollectCell.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 08/08/23.
//

import UIKit
import CreditCardForm
import StripePaymentsUI

class PaymentCollectCell: UICollectionViewCell {

    static let identifier = "PaymentCollectCell"
    static func nib() -> UINib {
        return UINib(nibName: "PaymentCollectCell", bundle: nil)
    }
    
    @IBOutlet weak var listCardPayment: CreditCardFormView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Func Credit Card
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        listCardPayment.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
        
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        listCardPayment.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        listCardPayment.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        listCardPayment.paymentCardTextFieldDidEndEditingCVC()
    }
}
