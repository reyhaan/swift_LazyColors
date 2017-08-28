//
//  PaletteColorsListHelper.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/27/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit
import CoreData

extension PaletteColorsList {
    
    func setupData() {
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        let c1 = NSEntityDescription.insertNewObject(forEntityName: "Color", into: context!) as! Color
        
        c1.name = "Red"
        c1.r = 123
        c1.g = 123
        c1.b = 123
        
        let c2 = NSEntityDescription.insertNewObject(forEntityName: "Color", into: context!) as! Color
        
        c2.name = "Blue"
        c2.r = 143
        c2.g = 231
        c2.b = 213
        
    }
    
    func loadData() {
        
        let delegate = (UIApplication.shared.delegate as? AppDelegate)
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest: NSFetchRequest<Color> = Color.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "belongsToPalette = %@", false as CVarArg)
            
            do {
                
                colorsArray = try context.fetch(fetchRequest)
                
            } catch let err {
                
                print(err)
            }
        }
        
    }
    
    func clearData() {
        let delegate = (UIApplication.shared.delegate as? AppDelegate)
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest: NSFetchRequest<Color> = Color.fetchRequest()
            
            do {
                
                let something: [Color] = try context.fetch(fetchRequest)
                
                for object in something {
                    context.delete(object)
                }
                
                do {
                    try context.save() // <- remember to put this :)
                } catch {
                    // Do something... fatalerror
                }
                
            } catch let err {
                
                print(err)
            }
        }
    }
    
}
