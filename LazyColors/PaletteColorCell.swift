//
//  PaletteColorCell.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/20/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

class PaletteColorCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var paletteObject: Palette? {
        didSet {
            paletteName.text = paletteObject?.name
            pl = [paletteObject?.color ?? "error"]
            
        }
    }

    var pl: NSSet?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        paletteColorCollectionView.register(ColorPaletteCell.self, forCellWithReuseIdentifier: cellId)
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
    
    let paletteName: UILabel = {
        let db = UILabel()
        db.textColor = UIColor.darkGray
        db.padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        db.font = UIFont(name: "ProximaNova-Bold", size: 12)
        return db
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellId = "cellId"
    
    lazy var paletteColorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor =  .gray // UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    func reloadData() {
        paletteColorCollectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ColorPaletteCell

        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width / CGFloat(6)), height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func setupViews() {
        
        buttonContainer.addSubview(paletteName)
        
        buttonContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: paletteName)
        buttonContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: paletteName)

        subContainer.layer.cornerRadius = 5
        subContainer.clipsToBounds = true
        subContainer.layer.masksToBounds = true
        
        parentContainer.layer.cornerRadius = 5
        parentContainer.clipsToBounds = true
        parentContainer.layer.masksToBounds = true
        
        parentContainer.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        parentContainer.layer.masksToBounds = false
        parentContainer.layer.shadowColor = UIColor.lightGray.cgColor
        parentContainer.layer.shadowRadius = 3.5
        parentContainer.layer.shadowOpacity = 0.3
        
        paletteContainer.addSubview(paletteColorCollectionView)
        paletteContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: paletteColorCollectionView)
        paletteContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: paletteColorCollectionView)
        
        subContainer.addSubview(buttonContainer)
        subContainer.addSubview(paletteContainer)
    
        subContainer.addConstraintsWithFormat(format: "V:|[v1(70)]-0-[v0(50)]|", views: buttonContainer, paletteContainer)
        subContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: paletteContainer)
        subContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: buttonContainer)
        
        parentContainer.addSubview(subContainer)
        parentContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: subContainer)
        parentContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: subContainer)
        
        addSubview(parentContainer)
        addConstraintsWithFormat(format: "V:|[v0(120)]|", views: parentContainer)
        addConstraintsWithFormat(format: "H:|[v0]|", views: parentContainer)
    }
}
