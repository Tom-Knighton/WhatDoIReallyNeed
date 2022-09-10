//
//  Home+CoreDataProperties.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 10/09/2022.
//
//

import Foundation
import CoreData


extension Home {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Home> {
        return NSFetchRequest<Home>(entityName: "Home")
    }

    @NSManaged public var homeColour: String
    @NSManaged public var homeName: String
    @NSManaged public var homeIcon: String

}

extension Home : Identifiable {

}
