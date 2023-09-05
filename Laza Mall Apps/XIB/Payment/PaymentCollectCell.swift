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
    
    private let creditCard: CreditCardFormView = {
        let card = CreditCardFormView()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    var cardModel: [CreditCard] = []
    var coreDataManage = CoreDataManage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCard()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        print(listCardPayment.frame.width, listCardPayment.frame.height, separator: " : ")
    }

    private func setupCard() {
        contentView.addSubview(creditCard)
        NSLayoutConstraint.activate([
            creditCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            creditCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            creditCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            creditCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    func fillCardDataFromCoreData(card: CreditCard) {
        let cardOwner = card.cardOwner
        let cardNumber = card.cardNumber
        let cardExpMonth = card.cardExpMonth
        let cardExpYear = card.cardExpYear
        let cvc = card.cardCvv

        print("Card Owner \(cardOwner)")
        print("Nomer kartu \(cardNumber)")
        print("epired month \(cardExpMonth)")
        print("expired year \(cardExpYear)")
        
        creditCard.paymentCardTextFieldDidChange(cardNumber: cardNumber, expirationYear: UInt(cardExpYear), expirationMonth: UInt(cardExpMonth), cvc: String(cvc))
        creditCard.cardHolderString = cardOwner
    }
}
