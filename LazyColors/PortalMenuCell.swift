//
//  PortalMenuCell.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/20/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

class PortalMenuCell: BaseCell {
    
    override var isSelected: Bool {
        didSet {
            container.backgroundColor = isSelected ? .orange : .white
            icon.image = isSelected ? icon.image?.maskWithColor(color: .orange) : icon.image?.maskWithColor(color: .lightGray)
        }
    }
    
    var container: UIView = {
        let cn = UIView()
        return cn
    }()
    
    var icon: UIImageView = {
        let ic = UIImageView()
        ic.contentMode = .scaleAspectFill
        return ic
    }()
    
    override func setupViews() {
        super.setupViews()
        
        container.frame.size.height = 2
        
        addSubview(icon)
        
        addConstraintsWithFormat(format: "V:[v0(18)]", views: icon)
        addConstraintsWithFormat(format: "H:[v0(18)]", views: icon)
        
        addConstraint(NSLayoutConstraint(item: icon, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: icon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        container.layer.cornerRadius = 2
        container.clipsToBounds = true
        container.layer.masksToBounds = true
        
        addSubview(container)
        
        addConstraintsWithFormat(format: "V:[v0(3)]|", views: container)
        addConstraintsWithFormat(format: "H:|[v0]|", views: container)
        
        addConstraint(NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        
        
    }
}
