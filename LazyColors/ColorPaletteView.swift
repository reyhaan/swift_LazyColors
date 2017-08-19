//
//  ColorPaletteView.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/16/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

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
        delegate?.closePalette()
        delegate2?.closePalette()
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

