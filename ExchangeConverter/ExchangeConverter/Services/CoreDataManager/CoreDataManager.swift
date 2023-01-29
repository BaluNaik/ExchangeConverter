//
//  CoreDataManager.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/27/23.
//

import Foundation
import CoreData

public extension NSManagedObject {
    
    static var entityName: String {
        return String(describing: self)
    }
}

class CoredataManager {
    
    public static var shared = CoredataManager()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExchangeConverter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchObjects(attributes: [AnyHashable:Any]) -> PairConversion? {
        var predicates = [NSPredicate]()
        for (key,value) in attributes {
            let newPredicate = NSPredicate(format: "%K = %@", argumentArray: [key,value])
            predicates.append(newPredicate)
        }
        
        let comoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        let fetchRequest: NSFetchRequest<PairConversion> = PairConversion.fetchRequest()
        fetchRequest.predicate = comoundPredicate
        do {
            let result = try self.context.fetch(fetchRequest)
            return result.first
        } catch {
            print(error)
            return nil
        }
    }
    
    
//    func fetchObjects<T: NSManagedObject>(attributes:[AnyHashable:Any], inputType:T.Type) -> [T]? {
//        var predicates = [NSPredicate]()
//        for (key,value) in attributes {
//            let newPredicate = NSPredicate(format: "%K = %@", argumentArray: [key,value])
//            predicates.append(newPredicate)
//        }
//
//        let comoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
//        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
//        fetchRequest.predicate = comoundPredicate
//        do {
//            let result = try self.context.fetch(fetchRequest)
//            return result
//
//        } catch {
//            print(error)
//            return nil
//        }
//    }
    
    func getConversionDetails(for model: PairConversionModel) -> PairConversion? {
        guard let model = CoredataManager.shared.fetchObjects(attributes: ["baseCode": model.base!,
                                                                           "targetCode": model.target!]) else {
            return nil
        }
        return model
    }
    
    func saveData(response: PairConversionModel) {
        if let baseCode = response.base,
           let target = response.target,
            let currency = CoredataManager.shared.fetchObjects(attributes: ["baseCode": baseCode, "targetCode": target]) {
            currency.baseCode = baseCode
            currency.targetCode = target
            if let timestamp = response.timestamp {
                currency.timeStamp = timestamp
            }
            if let conversionRate = response.conversionRate {
                currency.conversionRate = conversionRate
            }
        } else {
            let currency = PairConversion(context: CoredataManager.shared.context)
            currency.baseCode = response.base
            currency.targetCode = response.target
            if let timestamp = response.timestamp {
                currency.timeStamp = timestamp
            }
            if let conversionRate = response.conversionRate {
                currency.conversionRate = conversionRate
            }
        }
        CoredataManager.shared.saveContext()
    }
}
