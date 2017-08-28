//
//  ColorDetailController.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/26/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit
import CoreData

protocol PaletteDetailDelegate {
    func goBackToPortal()
}

class PaletteDetailController: UIViewController, UINavigationControllerDelegate, PaletteDetailDelegate {
    
    var selectedPalette: Palette?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
      
        setupViews()
        
        pd.delegate = self
        
    }
    
    let pd = PaletteDetail()
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pd.ccv.colorsArray = loadColorForPalette(palette: selectedPalette!)
        pd.ccv.reloadData()
    }
    
    func goBackToPortal() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadColorForPalette(palette: Palette) -> Array<Color> {
        
        let delegate = (UIApplication.shared.delegate as? AppDelegate)
        
        var colorArray: Array<Color>?
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest: NSFetchRequest<Color> = Color.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "palette = %@", palette)
            
            do {
                
                colorArray = try context.fetch(fetchRequest)
                
            } catch let err {
                
                print(err)
            }
        }
        
        return colorArray!
        
    }
    
    func setupViews() {
        
        view.addSubview(pd)
        
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: pd)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: pd)
        
    }
    
}
