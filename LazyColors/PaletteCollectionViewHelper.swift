//
//  PaletteCollectionViewHelper.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/20/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit
import CoreData

extension PaletteCollectionView {
    
    func setupData() {
        
        
    }
    
    func loadData() {
        
        let delegate = (UIApplication.shared.delegate as? AppDelegate)
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest: NSFetchRequest<Palette> = Palette.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "belongsToPalette = %@", false as CVarArg)
            
            do {
                
                palettesArray = try context.fetch(fetchRequest)
                
            } catch let err {
                
                print(err)
            }
        }
        
    }
    
    func clearData() {
        let delegate = (UIApplication.shared.delegate as? AppDelegate)
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest: NSFetchRequest<Palette> = Palette.fetchRequest()
            
            do {
                
                let something: [Palette] = try context.fetch(fetchRequest)
                
                for object in something {
                    context.delete(object)
                }
                
                do {
                    try context.save()
                } catch {
                    // Do something... fatalerror
                }
                
            } catch let err {
                
                print(err)
            }
        }
    }
    
}
