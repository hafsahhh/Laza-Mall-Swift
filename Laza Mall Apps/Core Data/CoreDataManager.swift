//
//  CoreDataManager.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 02/09/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataManage {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    // CREATE DATA IN CORE DATA
    func create(_ creditCard: CreditCard) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        let creditCardEntity = NSEntityDescription.entity(forEntityName: "LazaEntitiesCoredata", in: managedContext)

        let insert = NSManagedObject(entity: creditCardEntity!, insertInto: managedContext)
        insert.setValue(creditCard.cardOwner, forKey: "cardOwner")
        insert.setValue(creditCard.cardNumber, forKey: "cardNumber")
//        insert.setValue(creditCard.cardExp, forKey: "cardExp")
        insert.setValue(creditCard.cardExpMonth, forKey: "cardExpMonth")
        insert.setValue(creditCard.cardExpYear, forKey: "cardExpYear")
        insert.setValue(creditCard.cardCvv, forKey: "cardCvv")

        do {
            try managedContext.save()
            print("Saved data into Core Data")
        } catch let err {
            print("Failed to save data", err)
        }
    }

    // RETRIEVE DATA FROM CORE DATA
    func retrieve(completion: @escaping ([CreditCard]) -> Void) {
            var creditCard = [CreditCard]() // Mulai dengan array kosong
            
            let managedContext = appDelegate?.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LazaEntitiesCoredata")
            
            do {
                let result = try managedContext?.fetch(fetchRequest)
                result?.forEach { creditCardData in
                    let card = CreditCard(
                        cardOwner: creditCardData.value(forKey: "cardOwner") as! String,
                        cardNumber: creditCardData.value(forKey: "cardNumber") as! String,
                        cardExpMonth: creditCardData.value(forKey: "cardExpMonth") as! String,
                        cardExpYear: creditCardData.value(forKey: "cardExpYear") as! String,
                        cardCvv: creditCardData.value(forKey: "cardCvv") as! String
                    )
                    creditCard.append(card)
                }
                
                completion(creditCard) // Mengirimkan data yang ditemukan
                print("Success")
            } catch let error {
                print("Failed to fetch data", error)
            }
        }
//    func retrieve(completion: @escaping ([CreditCard])-> Void) {
//        var creditCards = [CreditCard]()
//        let managedContext = appDelegate?.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LazaEntitiesCoredata")
//
//        do {
//            let result = try managedContext?.fetch(fetchRequest)
//
//            result?.forEach { creditCardData in
//                let cardOwner = creditCardData.value(forKey: "cardOwner") as! String
//                let cardNumber = creditCardData.value(forKey: "cardNumber") as! String
////                let cardExp = creditCardData.value(forKey: "cardExp") as! String
//                let cardExpMonth = creditCardData.value(forKey: "cardExpMonth") as! String
//                let cardExpYear = creditCardData.value(forKey: "cardExpYear") as! String
//                let cardCvv = creditCardData.value(forKey: "cardCvv") as! String
//
//                let creditCard = CreditCard(cardOwner: cardOwner, cardNumber: cardNumber,
//                                            cardExpMonth: cardExpMonth, cardExpYear: cardExpYear, cardCvv: cardCvv)
//                creditCards.append(creditCard)
//            }
//        } catch let error {
//            print("Failed to fetch data", error)
//        }
////        return creditCards
//    }

    // UPDATE DATA IN CORE DATA
    func update(_ creditCard: CreditCard, cardNumber: String ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "LazaEntitiesCoredata")
        fetchRequest.predicate = NSPredicate(format: "cardNumber = %@", cardNumber)

        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)

            if let updateCardData = fetchedResults.first {
                updateCardData.setValue(creditCard.cardOwner, forKey: "cardOwner")
                updateCardData.setValue(creditCard.cardNumber, forKey: "cardNumber")
                updateCardData.setValue(creditCard.cardExpYear, forKey: "cardExpYear")
                updateCardData.setValue(creditCard.cardExpMonth, forKey: "cardExpMonth")
                updateCardData.setValue(creditCard.cardCvv, forKey: "cardCvv")
                do {
                    try managedContext.save()
                    print("Data updated successfully")
                } catch {
                    print("Failed to update data in core data")
                }
            }
        } catch {
            print("Failed to update data", error)
        }
    }

    // DELETE DATA FROM CORE DATA
    func delete(_ creditCard: CreditCard, completion: @escaping () -> Void) {
        // Managed context
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        // Fetch data to delete
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LazaEntitiesCoredata")
        fetchRequest.predicate = NSPredicate(format: "cardOwner = %@", creditCard.cardOwner)

        do {
            let result = try managedContext.fetch(fetchRequest)

            for dataToDelete in result {
                managedContext.delete(dataToDelete as! NSManagedObject)
            }

            try managedContext.save()
            completion()
        } catch let error {
            print("Unable to delete data", error)
        }
    }
}
