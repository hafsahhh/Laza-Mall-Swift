//
//  CardPayemntVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 02/09/23.
//

//import Foundation
//class PaymentViewModel {
//    
//    var cardModel: CreditCard?
//    var coredataManage = CoreDataManage()
//    
//    func saveBtnCreditCard() {
//        guard let cardOwner = cardModel?.cardOwner,
//              let cardNumber = cardModel?.cardNumber,
//              let cardExp = cardModel?.cardExp,
//              let cardCvv = cardModel?.cardCvv else {
//            // Jika salah satu atau semua nilai-nilai tidak ada, maka tidak dapat melanjutkan penyimpanan
//            print("Incomplete card data")
//            return
//        }
//        
//        // Membuat objek CreditCard dengan nilai-nilai yang sesuai
//        let saveCreditCard = CreditCard(
//            cardOwner: cardOwner,
//            cardNumber: cardNumber,
//            cardExp: cardExp,
//            cardCvv: cardCvv
//        )
//        
//        // Menyimpan data ke Core Data
//        coredataManage.create(saveCreditCard)
//        
//        print("Save credit card")
//    }
//}

