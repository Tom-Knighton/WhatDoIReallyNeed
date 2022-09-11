//
//  Home+CoreDataProperties.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 11/09/2022.
//
//

import Foundation
import CoreData


extension Home {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Home> {
        return NSFetchRequest<Home>(entityName: "Home")
    }

    @NSManaged public var homeId: String
    @NSManaged public var homeColour: String
    @NSManaged public var homeName: String
    @NSManaged public var homeIcon: String
    @NSManaged public var stockItems: Set<StockItem>

}

// MARK: Generated accessors for stockItems
extension Home {

    @objc(addStockItemsObject:)
    @NSManaged public func addToStockItems(_ value: StockItem)

    @objc(removeStockItemsObject:)
    @NSManaged public func removeFromStockItems(_ value: StockItem)

    @objc(addStockItems:)
    @NSManaged public func addToStockItems(_ values: NSSet)

    @objc(removeStockItems:)
    @NSManaged public func removeFromStockItems(_ values: NSSet)

}

extension Home : Identifiable {

}
