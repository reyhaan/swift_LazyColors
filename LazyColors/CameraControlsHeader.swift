//
//  CameraControlsHeader.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/6/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

class CameraControlsHeader: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerCollectionView.register(CameraControlsHeaderCell.self, forCellWithReuseIdentifier: cellId)
        headerCollectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        headerCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(-20, 0, 0, 0)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellId = "cellId"
    let imageNames = ["colors_white", "", "settings_white"]
    var isSettingsMenuVisible = false
    
    lazy var headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CameraControlsHeaderCell
        
        cell.button.setImage(UIImage(named: imageNames[indexPath.item]), for: UIControlState.normal)
        cell.button.imageView?.contentMode = .scaleAspectFit
        cell.button.imageView?.clipsToBounds = true
        cell.button.backgroundColor = UIColor.clear
        
        if indexPath.item == 0 {
            // Go to color's list
            
            
        } else if indexPath.item == 1 {
            // Capture the color
            cell.backgroundColor = UIColor.clear
            
        } else if indexPath.item == 2 {
            // Open settings
            cell.button.addTarget(self, action: #selector(self.openSettings), for: .touchDown)
        }
        
        return cell
    }
    
    func animateCameraOverlay(view: UIView!, values: Array<Any>, positionY: NSInteger) {
        let animation = CAKeyframeAnimation(keyPath: "position.y")
        animation.values = values
        animation.duration = TimeInterval(0.15)
        animation.calculationMode = kCAAnimationCubic
        view.layer.add(animation, forKey: nil)
        view.layer.position.y = CGFloat(positionY)
    }
    
    func openSettings(sender: UIButton!) {
        // Slide up the settings menu somehow (-_-)
        
        let footerView: UIView = (superview?.subviews[1])!
        
        if !isSettingsMenuVisible {
            
            isSettingsMenuVisible = true
            animateCameraOverlay(view: self, values: [90, 50], positionY: 50)
            animateCameraOverlay(view: footerView, values: [160, 120], positionY: 120)
            sender.setImage(UIImage(named: "close_white"), for: UIControlState.normal)
            
        } else {
            
            isSettingsMenuVisible = false
            animateCameraOverlay(view: self, values: [50, 100], positionY: 100)
            animateCameraOverlay(view: footerView, values: [120, 170], positionY: 170)
            sender.setImage(UIImage(named: "settings_white"), for: UIControlState.normal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func setupViews() {
        addSubview(headerCollectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: headerCollectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: headerCollectionView)
    }
}
