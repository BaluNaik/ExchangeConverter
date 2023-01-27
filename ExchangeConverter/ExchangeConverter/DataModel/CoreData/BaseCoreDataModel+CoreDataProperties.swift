//
//  BaseCoreDataModel+CoreDataProperties.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/27/23.
//
//

import Foundation
import CoreData


extension BaseCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseCoreDataModel> {
        return NSFetchRequest<BaseCoreDataModel>(entityName: "BaseCoreDataModel")
    }

    @NSManaged public var base: String?
    @NSManaged public var timeStamp: Double
    @NSManaged public var rates: NSSet?

}

// MARK: Generated accessors for rates
extension BaseCoreDataModel {

    @objc(addRatesObject:)
    @NSManaged public func addToRates(_ value: RateCoreDataModel)

    @objc(removeRatesObject:)
    @NSManaged public func removeFromRates(_ value: RateCoreDataModel)

    @objc(addRates:)
    @NSManaged public func addToRates(_ values: NSSet)

    @objc(removeRates:)
    @NSManaged public func removeFromRates(_ values: NSSet)

}

extension BaseCoreDataModel : Identifiable {

}
