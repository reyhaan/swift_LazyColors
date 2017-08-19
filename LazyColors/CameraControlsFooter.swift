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
    
    weak var delegate: ViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        footerCollectionView.register(CameraControlsFooterCell.self, forCellWithReuseIdentifier: cellId)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var isFrameFrozen = false
    
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
        
        cell.button.setImage(UIImage(named: imageNames[indexPath.item]), for: UIControlState.normal)
        cell.button.imageView?.contentMode = .scaleAspectFit
        cell.button.imageView?.clipsToBounds = true
        cell.button.backgroundColor = UIColor.clear
        
        if indexPath.item == 0 {
            // Freeze frame
            cell.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleFreezeFrame)))
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleFreezeFrame))) // .addTarget(self, action: #selector(self.toggleFreezeFrame), for: .touchDown)
            
        } else if indexPath.item == 1 {
            // Show hue slider
            cell.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openImagePicker)))
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openImagePicker)))
            
        } else if indexPath.item == 2 {
            // Activate flash
            cell.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleFlash)))
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleFlash)))
            
        } else if indexPath.item == 3 {
            // Generate collective pallette
            cell.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.generatePalette)))
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.generatePalette)))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func generatePalette() {
//        delegate?.generateColorPalette(image: <#CIImage#>)
    }
    
    func toggleFreezeFrame(sender: CameraControlsFooterCell!) {
        delegate?.toggleFrameFreeze()
    }
    
    func toggleFlash() {
        delegate?.toggleFlash()
    }
    
    func openImagePicker() {
        delegate?.openImagePicker()
    }
    
    func setupViews() {
        addSubview(footerCollectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: footerCollectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: footerCollectionView)
    }
}
