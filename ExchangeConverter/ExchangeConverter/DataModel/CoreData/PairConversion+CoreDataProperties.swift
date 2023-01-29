//
//  PairConversion+CoreDataProperties.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/29/23.
//
//

import Foundation
import CoreData


extension PairConversion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PairConversion> {
        return NSFetchRequest<PairConversion>(entityName: "PairConversion")
    }

    @NSManaged public var baseCode: String?
    @NSManaged public var targetCode: String?
    @NSManaged public var conversionRate: Double
    @NSManaged public var timeStamp: Double

}

extension PairConversion : Identifiable {

}
