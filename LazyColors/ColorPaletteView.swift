//
//  ColorPaletteView.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/16/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ColorPaletteView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: ViewControllerDelegate?
    weak var delegate2: ImagePickerViewControllerDelegate?
    
    public var palette: Array<UIColor>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        colorCollectionView.register(ColorPaletteCell.self, forCellWithReuseIdentifier: cellId)
        backgroundColor = UIColor.clear
        setupViews()
    }
    
    let parentContainer: UIView = {
        let pc = UIView()
        pc.backgroundColor = UIColor.white
        return pc
    }()
    
    let subContainer: UIView = {
        let sc = UIView()
        return sc
    }()
    
    let paletteContainer: UIView = {
        let pc = UIView()
        return pc
    }()
    
    let buttonContainer: UIView = {
        let bc = UIView()
        return bc
    }()
    
    let saveButton: UILabel = {
        let sb = UILabel()
        sb.text = "SAVE"
        sb.isUserInteractionEnabled = true
        sb.textAlignment = NSTextAlignment.right
        sb.textColor = UIColor.darkGray
        sb.padding = UIEdgeInsets(top: 0, left: 00, bottom: 0, right: 0)
        sb.font = UIFont(name: "ProximaNova-Bold", size: 12)
        return sb
    }()
    
    let discardButton: UILabel = {
        let db = UILabel()
        db.text = "DISCARD"
        db.isUserInteractionEnabled = true
        db.textColor = UIColor.darkGray
        db.padding = UIEdgeInsets(top: 0, left: 00, bottom: 0, right: 0)
        db.font = UIFont(name: "ProximaNova-Bold", size: 12)
        return db
    }()
    
    func closePalette() {
        animate(view: self, x: 10, y: -150, width: self.frame.width, height: self.frame.height)
    }
    
    func savePalette() {
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let colorPalette = NSEntityDescription.insertNewObject(forEntityName: "Palette", into: context!) as! Palette
        
        colorPalette.name = Date().toString()
        colorPalette.date = NSDate()
        
        let color1 = NSEntityDescription.insertNewObject(forEntityName: "Color", into: context!) as! Color
        let color2 = NSEntityDescription.insertNewObject(forEntityName: "Color", into: context!) as! Color
        let color3 = NSEntityDescription.insertNewObject(forEntityName: "Color", into: context!) as! Color
        let color4 = NSEntityDescription.insertNewObject(forEntityName: "Color", into: context!) as! Color
        let color5 = NSEntityDescription.insertNewObject(forEntityName: "Color", into: context!) as! Color
        let color6 = NSEntityDescription.insertNewObject(forEntityName: "Color", into: context!) as! Color
        
        for i in 0..<6 {
            
            let selectedColor = palette?[i]
            
            let c = selectedColor?.getCmyk()[0]
            let m = selectedColor?.getCmyk()[1]
            let y = selectedColor?.getCmyk()[2]
            let k = selectedColor?.getCmyk()[3]
            
            let h = selectedColor?.getHsl()[0]
            let s = selectedColor?.getHsl()[1]
            let l = selectedColor?.getHsl()[2]
      
            if i == 0 {
                
                color1.name = selectedColor?.getName()[1] as? String
                color1.r = Float((selectedColor?.redValue)!)
                color1.g = Float((selectedColor?.greenValue)!)
                color1.b = Float((selectedColor?.blueValue)!)
                color1.hex = selectedColor?.getHex()
                color1.date = NSDate()
                color1.rgb = selectedColor?.getRgb()
                color1.cmyk = "\(c!), \(m!), \(y!), \(k!)"
                color1.hsl = "\(h!), \(s!), \(l!)"
                color1.palette = colorPalette
                color1.belongsToPalette = true
            } else if i == 1 {
                
                color2.name = selectedColor?.getName()[1] as? String
                color2.r = Float((selectedColor?.redValue)!)
                color2.g = Float((selectedColor?.greenValue)!)
                color2.b = Float((selectedColor?.blueValue)!)
                color2.hex = selectedColor?.getHex()
                color2.date = NSDate()
                color2.rgb = selectedColor?.getRgb()
                color2.cmyk = "\(c!), \(m!), \(y!), \(k!)"
                color2.hsl = "\(h!), \(s!), \(l!)"
                color2.palette = colorPalette
                color2.belongsToPalette = true
            } else if i == 2 {
                
                color3.name = selectedColor?.getName()[1] as? String
                color3.r = Float((selectedColor?.redValue)!)
                color3.g = Float((selectedColor?.greenValue)!)
                color3.b = Float((selectedColor?.blueValue)!)
                color3.hex = selectedColor?.getHex()
                color3.date = NSDate()
                color3.rgb = selectedColor?.getRgb()
                color3.cmyk = "\(c!), \(m!), \(y!), \(k!)"
                color3.hsl = "\(h!), \(s!), \(l!)"
                color3.palette = colorPalette
                color3.belongsToPalette = true
            } else if i == 3 {
                
                color4.name = selectedColor?.getName()[1] as? String
                color4.r = Float((selectedColor?.redValue)!)
                color4.g = Float((selectedColor?.greenValue)!)
                color4.b = Float((selectedColor?.blueValue)!)
                color4.hex = selectedColor?.getHex()
                color4.date = NSDate()
                color4.rgb = selectedColor?.getRgb()
                color4.cmyk = "\(c!), \(m!), \(y!), \(k!)"
                color4.hsl = "\(h!), \(s!), \(l!)"
                color4.palette = colorPalette
                color4.belongsToPalette = true
            } else if i == 4 {
                
                color5.name = selectedColor?.getName()[1] as? String
                color5.r = Float((selectedColor?.redValue)!)
                color5.g = Float((selectedColor?.greenValue)!)
                color5.b = Float((selectedColor?.blueValue)!)
                color5.hex = selectedColor?.getHex()
                color5.date = NSDate()
                color5.rgb = selectedColor?.getRgb()
                color5.cmyk = "\(c!), \(m!), \(y!), \(k!)"
                color5.hsl = "\(h!), \(s!), \(l!)"
                color5.palette = colorPalette
                color5.belongsToPalette = true
            } else if i == 5 {
                
                color6.name = selectedColor?.getName()[1] as? String
                color6.r = Float((selectedColor?.redValue)!)
                color6.g = Float((selectedColor?.greenValue)!)
                color6.b = Float((selectedColor?.blueValue)!)
                color6.hex = selectedColor?.getHex()
                color6.date = NSDate()
                color6.rgb = selectedColor?.getRgb()
                color6.cmyk = "\(c!), \(m!), \(y!), \(k!)"
                color6.hsl = "\(h!), \(s!), \(l!)"
                color6.palette = colorPalette
                color6.belongsToPalette = true
            }
            
        }
        
        do {
            try context?.save()
            closePalette()
        }
        catch{
            print("There was an error in saving data")
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellId = "cellId"
    
    lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    func reloadData() {
        colorCollectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ColorPaletteCell
        
        if let color = palette?[indexPath.item] {
            cell?.colorObject = color
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width / CGFloat(6)), height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
  
    func setupViews() {
        
        discardButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closePalette)))
        
        saveButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.savePalette)))
        
        buttonContainer.addSubview(discardButton)
        buttonContainer.addSubview(saveButton)
        
        buttonContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: discardButton)
        buttonContainer.addConstraintsWithFormat(format: "H:|-20-[v0(80)]", views: discardButton)
        
        buttonContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: saveButton)
        buttonContainer.addConstraintsWithFormat(format: "H:[v0(80)]-20-|", views: saveButton)
        
        paletteContainer.addSubview(colorCollectionView)
        paletteContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: colorCollectionView)
        paletteContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: colorCollectionView)
        
        subContainer.addSubview(buttonContainer)
        subContainer.addSubview(paletteContainer)
        
        subContainer.addConstraintsWithFormat(format: "V:|[v1(70)]-0-[v0(50)]|", views: buttonContainer, paletteContainer)
        subContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: paletteContainer)
        subContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: buttonContainer)
        
        parentContainer.layer.cornerRadius = 5
        parentContainer.clipsToBounds = true
        parentContainer.layer.masksToBounds = true
        
        parentContainer.addSubview(subContainer)
        parentContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: subContainer)
        parentContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: subContainer)
        
        addSubview(parentContainer)
        addConstraintsWithFormat(format: "V:|[v0(120)]", views: parentContainer)
        addConstraintsWithFormat(format: "H:|[v0]|", views: parentContainer)
    }
}

