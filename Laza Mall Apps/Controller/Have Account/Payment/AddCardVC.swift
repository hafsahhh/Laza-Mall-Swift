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
    let paymentTextField = STPPaymentCardTextField()
    var cardModels = [CreditCard]()
    var coredataManage = CoreDataManage()
    var modelProfile : DataUseProfile?
    
    @IBOutlet weak var cardNumberText: STPPaymentCardTextField!
    {
        didSet {
            cardNumberText.delegate = self
        }
    }

    @IBOutlet weak var cardNameText: UITextField!{
        didSet {
            cardNameText.addTarget(self, action: #selector(cardNameTextChanged(_:)), for: .editingChanged)
        }
    }
    
    @objc func cardNameTextChanged(_ textField: UITextField) {
        creditCardView.cardHolderString = textField.text ?? ""
    }
    
    
    @IBOutlet weak var creditCardView: CreditCardFormView!
    
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
//        let backToPayment = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
//        self.navigationController?.pushViewController(backToPayment, animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - View Didload
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn

        cardNumberText.postalCodeEntryEnabled = false
        paymentTextField.delegate = self
        cardParams = STPPaymentMethodCardParams()
        self.cardNumberText.paymentMethodParams.card = cardParams
        

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
        saveCardModelToCoreData()
        // Cek apakah ada instance PaymentViewController yang sudah ada dalam navigation stack
        var foundCardViewController: PaymentVC?
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if let cardViewController = viewController as? PaymentVC {
                    foundCardViewController = cardViewController
                    break
                }
            }
        }

        if let existingCardViewController = foundCardViewController {
            // Jika sudah ada, tinggal perbarui data kartu dan kembali ke tampilan tersebut
            existingCardViewController.cardModels = cardModels
            self.navigationController?.popToViewController(existingCardViewController, animated: false)
        } else {
            // Jika belum ada, buat instance baru dan tambahkan ke navigation stack
            let addCard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PaymentVC") as! PaymentVC
            addCard.cardModels = cardModels
            self.navigationController?.pushViewController(addCard, animated: false)
        }
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cardNameText {
            textField.resignFirstResponder()
            paymentTextField.becomeFirstResponder()
        } else if textField == cardNameText  {
            textField.resignFirstResponder()
        }
        return true
    }

    func saveCardModelToCoreData() {
        
        //save id into coredata
        guard let dataUser = KeychainManager.shared.getProfileFromKeychain(service: "UserProfileCoreData") else {return}
        
        let cardOwner = cardNameText.text ?? ""
        let cardNumber = cardNumberText.cardNumber ?? ""
        let cardExpMonth = cardNumberText.expirationMonth
        let cardYear = cardNumberText.expirationYear
        let cardCvv = Int(cardNumberText.cvc ?? "123") ?? 133
        
        let newCard = CreditCard(
            cardOwner: cardOwner,
            cardNumber: cardNumber,
            cardExpMonth: Int16(cardExpMonth),
            cardExpYear: Int16(cardYear),
            cardCvv: Int16(cardCvv),
            userId: Int32(dataUser.id)
        )
        print("list new card\(newCard)")
        coredataManage.create(newCard) // Save the new card to Core Data
            
            // Menambahkan kartu baru ke dalam array
            cardModels.append(newCard)
            
            print("Sukses menyimpan kartu ke Core Data")
    }
}
