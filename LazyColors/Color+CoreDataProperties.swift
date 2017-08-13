//
//  Color+CoreDataProperties.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/9/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import CoreData


extension Color {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Color> {
        return NSFetchRequest<Color>(entityName: "Color")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var r: Int16
    @NSManaged public var g: Int16
    @NSManaged public var b: Int16
    @NSManaged public var hex: String?
    @NSManaged public var rgb: String?
    @NSManaged public var cmyk: String?
    @NSManaged public var hsl: String?
    @NSManaged public var shades: String?

}
