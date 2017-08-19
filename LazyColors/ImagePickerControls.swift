//
//  ImagePickerControls.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/16/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ImagePickerControls: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: ImagePickerViewControllerDelegate?
    
    var colorCollection: ColorCollectionView?
    
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
    let imageNames = ["colors_white", "", ""]
    var isSettingsMenuVisible = false
    
    let cname = ColorNameContainer()
    
    lazy var headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    let previewImageView: UIImageView = {
        let pi = UIImageView()
        return pi
    }()
    
    let colorCollectionView = ColorCollectionView()
    
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
            
            cell.button.frame.size.height = 80
            cell.button.frame.size.width = 80
            cell.button.frame.origin.x = 12
            cell.button.frame.origin.y = 22
            
            cell.button.addTarget(self, action: #selector(self.openColorListViewController), for: .touchDown)
            
        } else if indexPath.item == 1 {
            // Capture the color
            cell.backgroundColor = UIColor.clear
            
            cell.button.frame.size.height = 80
            cell.button.frame.size.width = 80
            cell.button.frame.origin.x = 12
            cell.button.frame.origin.y = 25
            cell.button.layer.cornerRadius = 40
            cell.button.clipsToBounds = true
            
            cell.button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cell.button.layer.masksToBounds =  false
            cell.button.layer.shadowColor = UIColor.black.cgColor
            cell.button.layer.shadowRadius = 3.0
            cell.button.layer.shadowOpacity = 0.4
            
            cell.button.addTarget(self, action: #selector(self.saveColor), for: .touchDown)
            
        } else if indexPath.item == 2 {
            // Open settings
            
            cell.button.frame.size.height = 80
            cell.button.frame.size.width = 80
            cell.button.frame.origin.x = 12
            cell.button.frame.origin.y = 22
            
        }
        
        return cell
    }
    
    func openColorListViewController() {
        delegate?.openColorsList()
    }
    
    func animateCameraOverlay(view: UIView!, values: Array<Any>, positionY: NSInteger) {
        let animation = CAKeyframeAnimation(keyPath: "position.y")
        animation.values = values
        animation.duration = TimeInterval(0.15)
        animation.calculationMode = kCAAnimationCubic
        view.layer.add(animation, forKey: nil)
        view.layer.position.y = CGFloat(positionY)
    }
    
    func saveColor(sender: UIButton!) {
        // Save current color
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let color = NSEntityDescription.insertNewObject(forEntityName: "Color", into: context!) as! Color
        
        let selectedColor = sender.backgroundColor
        
        let c = selectedColor?.getCmyk()[0]
        let m = selectedColor?.getCmyk()[1]
        let y = selectedColor?.getCmyk()[2]
        let k = selectedColor?.getCmyk()[3]
        
        let h = selectedColor?.getHsl()[0]
        let s = selectedColor?.getHsl()[1]
        let l = selectedColor?.getHsl()[2]
        
        print(selectedColor?.getName() ?? "error")
        
        color.name = selectedColor?.getName()[1] as? String
        color.r = Float((selectedColor?.redValue)!)
        color.g = Float((selectedColor?.greenValue)!)
        color.b = Float((selectedColor?.blueValue)!)
        color.hex = selectedColor?.getHex()
        color.date = NSDate()
        color.rgb = selectedColor?.getRgb()
        color.cmyk = "\(c!), \(m!), \(y!), \(k!)"
        color.hsl = "\(h!), \(s!), \(l!)"
        
        
        do {
            try context?.save()
        }
        catch{
            print("There was an error in saving data")
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
        addSubview(cname)
        
        addConstraintsWithFormat(format: "V:|[v0(90)]-0-[v1(40)]|", views: headerCollectionView, cname)
        addConstraintsWithFormat(format: "H:|[v0]|", views: headerCollectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: cname)
    }
}
