//
//  RateCoreDataModel+CoreDataProperties.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/27/23.
//
//

import Foundation
import CoreData


extension RateCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RateCoreDataModel> {
        return NSFetchRequest<RateCoreDataModel>(entityName: "RateCoreDataModel")
    }

    @NSManaged public var currency: String?
    @NSManaged public var rate: Double

}

extension RateCoreDataModel : Identifiable {

}
