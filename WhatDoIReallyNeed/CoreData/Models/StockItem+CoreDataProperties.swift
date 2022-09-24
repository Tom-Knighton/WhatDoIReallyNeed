//
//  StockItem+CoreDataProperties.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 11/09/2022.
//
//

import Foundation
import CoreData


extension StockItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockItem> {
        return NSFetchRequest<StockItem>(entityName: "StockItem")
    }

    @NSManaged public var autoAddWhenLow: Bool
    @NSManaged public var homeId: String
    @NSManaged public var itemAmount: Int
    @NSManaged public var itemName: String
    @NSManaged public var home: Home?

}

extension StockItem : Identifiable {

}
