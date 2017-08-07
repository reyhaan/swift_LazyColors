//
//  CameraControlsHeaderCell.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/7/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

class CameraControlsHeaderCell: BaseCell {
    
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "big_camera")
        return iv
    }()
    
    let button: UIButton = {
        let bt = UIButton()
        return bt
    }()
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                super.isSelected = true
                
            } else if newValue == false {
                super.isSelected = false
                
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(button)
        addConstraintsWithFormat(format: "H:[v0(20)]", views: button)
        addConstraintsWithFormat(format: "V:[v0(20)]", views: button)
        
        addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

    }
}
