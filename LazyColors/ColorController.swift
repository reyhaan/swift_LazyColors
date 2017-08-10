//
//  ColorController.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/9/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit
import CoreData

extension ViewController {
    
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
    
}
