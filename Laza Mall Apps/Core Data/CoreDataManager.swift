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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let creditCardEntity = LazaEntitiesCoredata(context: managedContext)
        creditCardEntity.cardOwner = creditCard.cardOwner
        creditCardEntity.cardNumber = creditCard.cardNumber
        creditCardEntity.cardExpMonth = creditCard.cardExpMonth
        creditCardEntity.cardExpYear = creditCard.cardExpYear
        creditCardEntity.cardCvv = creditCard.cardCvv
        creditCardEntity.userId = creditCard.userId

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
        
        //check user id from useer default
        guard let data = UserDefaults.standard.object(forKey: "UserProfileDefault") as? Data,
           let profile = try? JSONDecoder().decode(profileUser.self, from: data) else { return }
        let userID = profile.data.id
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LazaEntitiesCoredata")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "userId = %@", String(userID))
        ])
        
        do {
            let result = try managedContext?.fetch(fetchRequest)
            result?.forEach { creditCardData in
                let card = CreditCard(
                    cardOwner: creditCardData.value(forKey: "cardOwner") as! String,
                    cardNumber: creditCardData.value(forKey: "cardNumber") as! String,
                    cardExpMonth: creditCardData.value(forKey: "cardExpMonth") as! Int16,
                    cardExpYear: creditCardData.value(forKey: "cardExpYear") as! Int16,
                    cardCvv: creditCardData.value(forKey: "cardCvv") as! Int16,
                    userId: creditCardData.value(forKey: "userId") as! Int32
                )
                creditCard.append(card)
            }
            
            completion(creditCard) // Mengirimkan data yang ditemukan
            print("Success fetch core data")
        } catch let error {
            print("Failed to fetch data", error)
        }
    }


    // UPDATE DATA IN CORE DATA
    func update(_ creditCard: CreditCard, cardNumber: String ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //check user id from useer default
        guard let data = UserDefaults.standard.object(forKey: "UserProfileDefault") as? Data,
           let profile = try? JSONDecoder().decode(profileUser.self, from: data) else { return }
        let userID = profile.data.id

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "LazaEntitiesCoredata")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "cardNumber = %@", cardNumber),
            NSPredicate(format: "userId = %@", String(userID))
        ])

        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)

            if let updateCardData = fetchedResults.first {
                updateCardData.setValue(creditCard.cardOwner, forKey: "cardOwner")
                updateCardData.setValue(creditCard.cardNumber, forKey: "cardNumber")
                updateCardData.setValue(creditCard.cardExpYear, forKey: "cardExpYear")
                updateCardData.setValue(creditCard.cardExpMonth, forKey: "cardExpMonth")
                updateCardData.setValue(creditCard.cardCvv, forKey: "cardCvv")
                updateCardData.setValue(creditCard.userId, forKey: "userId")
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
        
        //check user id from useer default
        guard let data = UserDefaults.standard.object(forKey: "UserProfileDefault") as? Data,
           let profile = try? JSONDecoder().decode(profileUser.self, from: data) else { return }
        let userID = profile.data.id

        // Fetch data to delete
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LazaEntitiesCoredata")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "cardNumber = %@", creditCard.cardNumber),
            NSPredicate(format: "userId = %@", String(userID))
        ])

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
