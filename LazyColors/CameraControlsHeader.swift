//
//  CameraControlsHeader.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/6/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CameraControlsHeader: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: ViewControllerDelegate?
    
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
    let imageNames = ["list_white", "", "settings_white"]
    var isSettingsMenuVisible = false
    
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
    
    let fabButton = FabButtonView()
    
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
        
        cell.button.imageView?.frame.size.height = 20
        cell.button.imageView?.frame.size.width = 20
        
        if indexPath.item == 0 {
            // Go to color's list
            
            cell.container.frame.size.width = 46
            cell.container.frame.size.height = 46
            cell.container.frame.origin.x = 30
            cell.container.frame.origin.y = 24
            
            cell.button.frame.size.height = 46
            cell.button.frame.size.width = 46
            cell.button.frame.origin.x = 0  // 30
            cell.button.frame.origin.y = 0  // 24
            
            cell.button.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
            
            cell.button.layer.cornerRadius = 23
            cell.button.clipsToBounds = true
            
            cell.button.addTarget(self, action: #selector(self.openColorPortalViewController), for: .touchDown)
     
        } else if indexPath.item == 1 {
            // Capture the color
            cell.container.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.2)  // UIColor(red: 120/255.0, green: 120/255.0, blue: 120/255.0, alpha: 0.2)
            cell.container.frame.size.width = 90
            cell.container.frame.size.height = 90
            cell.container.layer.cornerRadius = 45
            cell.container.clipsToBounds = true
            
            cell.container.frame = CGRect(x: (cell.frame.size.width / 2) - (cell.container.frame.width / 2), y: 0, width: 90, height: 90)
            
            cell.button.backgroundColor = UIColor.blue
            
            cell.button.frame.size.width = 76
            cell.button.frame = CGRect(x: (cell.container.frame.size.width / 2) - (cell.button.frame.width / 2), y: 7, width: 76, height: 76)
            
            cell.button.layer.cornerRadius = 38
            cell.button.clipsToBounds = true
            
            cell.button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cell.button.layer.masksToBounds =  false
            cell.button.layer.shadowColor = UIColor.black.cgColor
            cell.button.layer.shadowRadius = 3.0
            cell.button.layer.shadowOpacity = 0.4
            
            cell.button.addTarget(self, action: #selector(self.saveColor), for: .touchDown)
            
        } else if indexPath.item == 2 {
            // Open settings
            
            cell.addSubview(fabButton)
            
            fabButton.frame.size.height = 50
            fabButton.frame.size.width = 50
            fabButton.frame.origin.x = (cell.frame.size.width / 2) - (fabButton.frame.size.width / 2)
            fabButton.frame.origin.y = (cell.frame.size.height / 2) - (fabButton.frame.size.height / 2)
            
        }
        
        return cell
    }
    
    func openColorPortalViewController() {
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
    
    func animate(view: UIView!, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                view.frame = CGRect(x: x, y: y, width: width, height: height)
        },
            completion: nil
        )
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
        color.belongsToPalette = false
        
        
        do {
            try context?.save()
        }
        catch{
            print("There was an error in saving data")
        }
    }
    
    func openColorList(sender: UIButton!) {
        // open the list of collected colors
        
        if let window = UIApplication.shared.keyWindow {
            
            delegate?.freezeFrame()

            colorCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: (window.frame.height))
            window.addSubview(colorCollectionView)
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: {
                    self.colorCollectionView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            },
                completion: nil
            )
            
            colorCollectionView.loadData()
            colorCollectionView.colorCollectionView.reloadData()
        }

    }
    
    func openSettings(sender: UIButton!) {
        // Slide up the settings menu somehow (-_-)
        
        let footerView: UIView = (superview?.subviews[1])!
        let labelView: UIView = (superview?.subviews[2])!
        
        if !isSettingsMenuVisible {
            
            isSettingsMenuVisible = true
            
            animate(view: self, x: 0, y: 10, width: self.frame.width, height: 90)
            
            animate(view: footerView, x: 0, y: self.frame.height + 10, width: self.frame.width, height: 40)
            
            animate(view: labelView, x: 0, y: -40, width: self.frame.width, height: 40)
            
            sender.setImage(UIImage(named: "close_white"), for: UIControlState.normal)
            
        } else {
            
            isSettingsMenuVisible = false
            
            animate(view: self, x: 0, y: 50, width: self.frame.width, height: 90)
            
            animate(view: footerView, x: 0, y: self.frame.height + 50, width: self.frame.width, height: 40)
            
            animate(view: labelView, x: 0, y: 0, width: self.frame.width, height: 40)
            
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
