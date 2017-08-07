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
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(icon)
        addConstraintsWithFormat(format: "H:[v0(18)]", views: icon)
        addConstraintsWithFormat(format: "V:[v0(18)]", views: icon)
        
        addConstraint(NSLayoutConstraint(item: icon, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: icon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

    }
}
