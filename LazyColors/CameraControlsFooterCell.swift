//
//  CameraControlsFooterCell.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/7/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

class CameraControlsFooterCell: BaseCell {
    
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "camera")
        return iv
    }()
    
    let button: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(button)
        addConstraintsWithFormat(format: "H:[v0(22)]", views: button)
        addConstraintsWithFormat(format: "V:[v0(22)]", views: button)
        
        addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

    }
}
