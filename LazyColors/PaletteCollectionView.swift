//
//  PaletteCollectionView.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/20/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

protocol PaletteCollectionDelegate {
    func reloadData()
}

class PaletteCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PaletteCollectionDelegate {
    
    weak var delegate: PreviewControllerDelegate?
    weak var delegate2: ViewControllerDelegate?
    var palettesArray: [Palette]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        paletteCollectionView.register(PaletteColorCell.self, forCellWithReuseIdentifier: cellId)
        setupViews()
        loadData()
//        clearData()
        
    }
    
    let pdc = PaletteDetailController()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData() {
        loadData()
        pdc.pd.ccv.reloadData(object: nil)
        paletteCollectionView.reloadData()
    }
    
    let cellId = "cellId"
    
    lazy var paletteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = palettesArray?.count {
            return  count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PaletteColorCell

        if let palette = palettesArray?[indexPath.item] {
            cell?.paletteObject = palette
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 20, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appDelegate : AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        if let unwrappedAppdelegate = appDelegate {
            
            pdc.selectedPalette = self.palettesArray?[indexPath.item]
            
            unwrappedAppdelegate.window!.rootViewController?.present(pdc, animated: true, completion: nil)
        }
        print("selected")
    }
    
    func setupViews() {
        
        paletteCollectionView.showsVerticalScrollIndicator = false

        addSubview(paletteCollectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: paletteCollectionView)
        addConstraintsWithFormat(format: "H:|-0-[v0]-0-|", views: paletteCollectionView)
    }
    
}
