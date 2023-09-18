//
//  CaloricInfo+CoreDataProperties.swift
//  CalorieTracking
//
//  Created by Sara Gaya on 9/17/23.
//
//

import Foundation
import CoreData


extension CaloricInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CaloricInfo> {
        return NSFetchRequest<CaloricInfo>(entityName: "CaloricInfo")
    }

    @NSManaged public var caloricGoal: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var totalCaloricIntake: Int64

}

extension CaloricInfo : Identifiable {

}
