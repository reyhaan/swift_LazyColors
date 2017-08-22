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
            
        let c = palette?[0].getCmyk()[0]
        let m = palette?[0].getCmyk()[1]
        let y = palette?[0].getCmyk()[2]
        let k = palette?[0].getCmyk()[3]
        
        let h = palette?[0].getHsl()[0]
        let s = palette?[0].getHsl()[1]
        let l = palette?[0].getHsl()[2]
        
        // -------------------
        
        let c1 = palette?[1].getCmyk()[0]
        let m1 = palette?[1].getCmyk()[1]
        let y1 = palette?[1].getCmyk()[2]
        let k1 = palette?[1].getCmyk()[3]
        
        let h1 = palette?[1].getHsl()[0]
        let s1 = palette?[1].getHsl()[1]
        let l1 = palette?[1].getHsl()[2]
        
        //---------------------
        
        let c2 = palette?[2].getCmyk()[0]
        let m2 = palette?[2].getCmyk()[1]
        let y2 = palette?[2].getCmyk()[2]
        let k2 = palette?[2].getCmyk()[3]
       
        let h2 = palette?[2].getHsl()[0]
        let s2 = palette?[2].getHsl()[1]
        let l2 = palette?[2].getHsl()[2]
        
        //---------------------
        
        let c3 = palette?[3].getCmyk()[0]
        let m3 = palette?[3].getCmyk()[1]
        let y3 = palette?[3].getCmyk()[2]
        let k3 = palette?[3].getCmyk()[3]
        
        let h3 = palette?[3].getHsl()[0]
        let s3 = palette?[3].getHsl()[1]
        let l3 = palette?[3].getHsl()[2]
        
        //-----------------------
        
        let c4 = palette?[4].getCmyk()[0]
        let m4 = palette?[4].getCmyk()[1]
        let y4 = palette?[4].getCmyk()[2]
        let k4 = palette?[4].getCmyk()[3]
        
        let h4 = palette?[4].getHsl()[0]
        let s4 = palette?[4].getHsl()[1]
        let l4 = palette?[4].getHsl()[2]
        
        //-------------------------
        
        let c5 = palette?[5].getCmyk()[0]
        let m5 = palette?[5].getCmyk()[1]
        let y5 = palette?[5].getCmyk()[2]
        let k5 = palette?[5].getCmyk()[3]
        
        let h5 = palette?[5].getHsl()[0]
        let s5 = palette?[5].getHsl()[1]
        let l5 = palette?[5].getHsl()[2]
      

        
                color1.name = palette?[0].getName()[1] as? String
                color1.r = Float((palette?[0].redValue)!)
                color1.g = Float((palette?[0].greenValue)!)
                color1.b = Float((palette?[0].blueValue)!)
                color1.hex = palette?[0].getHex()
                color1.date = NSDate()
                color1.rgb = palette?[0].getRgb()
                color1.cmyk = "\(c!), \(m!), \(y!), \(k!)"
                color1.hsl = "\(h!), \(s!), \(l!)"
                color1.palette = colorPalette
                color1.belongsToPalette = true

                
                color2.name = palette?[1].getName()[1] as? String
                color2.r = Float((palette?[1].redValue)!)
                color2.g = Float((palette?[1].greenValue)!)
                color2.b = Float((palette?[1].blueValue)!)
                color2.hex = palette?[1].getHex()
                color2.date = NSDate()
                color2.rgb = palette?[1].getRgb()
                color2.cmyk = "\(c1!), \(m1!), \(y1!), \(k1!)"
                color2.hsl = "\(h1!), \(s1!), \(l1!)"
                color2.palette = colorPalette
                color2.belongsToPalette = true

                
                color3.name = palette?[2].getName()[1] as? String
                color3.r = Float((palette?[2].redValue)!)
                color3.g = Float((palette?[2].greenValue)!)
                color3.b = Float((palette?[2].blueValue)!)
                color3.hex = palette?[2].getHex()
                color3.date = NSDate()
                color3.rgb = palette?[2].getRgb()
                color3.cmyk = "\(c2!), \(m2!), \(y2!), \(k2!)"
                color3.hsl = "\(h2!), \(s2!), \(l2!)"
                color3.palette = colorPalette
                color3.belongsToPalette = true

                
                color4.name = palette?[3].getName()[1] as? String
                color4.r = Float((palette?[3].redValue)!)
                color4.g = Float((palette?[3].greenValue)!)
                color4.b = Float((palette?[3].blueValue)!)
                color4.hex = palette?[3].getHex()
                color4.date = NSDate()
                color4.rgb = palette?[3].getRgb()
                color4.cmyk = "\(c3!), \(m3!), \(y3!), \(k3!)"
                color4.hsl = "\(h3!), \(s3!), \(l3!)"
                color4.palette = colorPalette
                color4.belongsToPalette = true

                
                color5.name = palette?[4].getName()[1] as? String
                color5.r = Float((palette?[4].redValue)!)
                color5.g = Float((palette?[4].greenValue)!)
                color5.b = Float((palette?[4].blueValue)!)
                color5.hex = palette?[4].getHex()
                color5.date = NSDate()
                color5.rgb = palette?[4].getRgb()
                color5.cmyk = "\(c4!), \(m4!), \(y4!), \(k4!)"
                color5.hsl = "\(h4!), \(s4!), \(l4!)"
                color5.palette = colorPalette
                color5.belongsToPalette = true

                
                color6.name = palette?[5].getName()[1] as? String
                color6.r = Float((palette?[5].redValue)!)
                color6.g = Float((palette?[5].greenValue)!)
                color6.b = Float((palette?[5].blueValue)!)
                color6.hex = palette?[5].getHex()
                color6.date = NSDate()
                color6.rgb = palette?[5].getRgb()
                color6.cmyk = "\(c5!), \(m5!), \(y5!), \(k5!)"
                color6.hsl = "\(h5!), \(s5!), \(l5!)"
                color6.palette = colorPalette
                color6.belongsToPalette = true

        
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

