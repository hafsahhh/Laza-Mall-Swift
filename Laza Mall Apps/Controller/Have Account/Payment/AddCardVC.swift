//
//  AddCardVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 07/08/23.
//

import UIKit
import CreditCardForm
import Stripe

class AddCardVC: UIViewController, STPPaymentCardTextFieldDelegate {
    
    private var cardParams: STPPaymentMethodCardParams!
    
    @IBOutlet var cardOwnerText: STPPaymentCardTextField! {
        didSet {
//            cardOwnerText.delegate = self
        }
    }
    @IBOutlet weak var cardNumberText: STPPaymentCardTextField!
    {
        didSet {
            cardNumberText.delegate = self
        }
    }
    
    
//    @IBOutlet weak var cardExpText: STPPaymentCardTextField!
//
//    @IBOutlet weak var cardCvvText: STPPaymentCardTextField!
    
    @IBOutlet weak var creditCardView: CreditCardFormView!{
        didSet{
            creditCardView.cardHolderString = "Siti Hafsah"
            creditCardView.cardGradientColors[Brands.Amex.rawValue] = [UIColor.red, UIColor.black]
            creditCardView.cardNumberFont = UIFont(name: "HelveticaNeue", size: 20)!
            creditCardView.cardPlaceholdersFont = UIFont(name: "HelveticaNeue", size: 10)!
            creditCardView.cardTextFont = UIFont(name: "HelveticaNeue", size: 12)!
        }
    }
    
    //Back Button
    private lazy var backBtn : UIButton = {
        //call back button
        let backBtn = UIButton.init(type: .custom)
        backBtn.setImage(UIImage(named:"Back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        backBtn.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        

        return backBtn
    }()

    //Back Button
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
        
        cardNumberText.postalCodeEntryEnabled = false
        removeCVC()
        removeEXP()
        
        cardParams = STPPaymentMethodCardParams()
        cardParams.number = cardNumberText.cardNumber
//        cardParams.expMonth = (Int(cardExpText.expirationMonth)) as NSNumber
//        cardParams.expYear = (Int(cardExpText.expirationYear)) as NSNumber
        cardParams.expMonth = 03
        cardParams.expYear = 23
        cardParams.cvc = "1234"

        
        self.cardNumberText.paymentMethodParams.card = cardParams

    }
    
    func removeEXP() {
        if let fieldsView = cardNumberText.subviews.first {
            for view in fieldsView.subviews where view.tag == 1 {
                // set a default cvc for the validator and remove the field
                (view as? UITextField)?.text = "1234"
                view.removeFromSuperview()
            }
        }
    }
    
    func removeCVC() {
        if let fieldsView = cardNumberText.subviews.first {
            for view in fieldsView.subviews where view.tag == 2 {
                // set a default cvc for the validator and remove the field
                (view as? UITextField)?.text = "1234"
                view.removeFromSuperview()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // load saved card params
    
        
        creditCardView.paymentCardTextFieldDidChange(cardNumber: cardParams.number, expirationYear: cardParams.expYear as? UInt, expirationMonth: cardParams.expMonth as? UInt)
        
    }

    
    func savedCard (){
        creditCardView.paymentCardTextFieldDidChange(cardNumber: cardParams.number, expirationYear: cardParams!.expYear as? UInt, expirationMonth: cardParams!.expMonth as? UInt, cvc: cardParams.cvc)
    }
    
    
    // MARK: - Navigation
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
        
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
    }
    
    
    @IBAction func addNewCard(_ sender: UIButton) {
        savedCard()
        let addCard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PaymentVC") as! PaymentVC
        self.navigationController?.pushViewController(addCard, animated: true)
    }
    
}
extension AddCardVC: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        creditCardView.cardHolderString = textField.text!
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cardOwnerText {
            textField.resignFirstResponder()
            cardNumberText.becomeFirstResponder()
        } else if textField == cardNumberText  {
            textField.resignFirstResponder()
        }
        return true
    }
}
