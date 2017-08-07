//
//  CameraControlsFooter.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/6/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

class CameraControlsFooter: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
        footerCollectionView.register(CameraControlsFooterCell.self, forCellWithReuseIdentifier: cellId)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellId = "cellId"
    let imageNames = ["freeze_white", "hue_white", "flash_white", "color_blind_white"]
    
    lazy var footerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CameraControlsFooterCell
        cell.icon.image = UIImage(named: imageNames[indexPath.item])
        cell.icon.contentMode = .scaleAspectFit
        cell.icon.clipsToBounds = true
        
        if indexPath.item == 0 {
            // Freeze frame
            
            
        } else if indexPath.item == 1 {
            // Show hue slider
            
            
        } else if indexPath.item == 2 {
            // Activate flash
            
            
        } else if indexPath.item == 3 {
            // Enable color blind mode
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func setupViews() {
        addSubview(footerCollectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: footerCollectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: footerCollectionView)
    }
}
