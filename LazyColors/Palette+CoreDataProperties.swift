//
//  Palette+CoreDataProperties.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/20/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import CoreData


extension Palette {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Palette> {
        return NSFetchRequest<Palette>(entityName: "Palette")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var color: NSSet?

}

// MARK: Generated accessors for color
extension Palette {

    @objc(addColorObject:)
    @NSManaged public func addToColor(_ value: Color)

    @objc(removeColorObject:)
    @NSManaged public func removeFromColor(_ value: Color)

    @objc(addColor:)
    @NSManaged public func addToColor(_ values: NSSet)

    @objc(removeColor:)
    @NSManaged public func removeFromColor(_ values: NSSet)

}
