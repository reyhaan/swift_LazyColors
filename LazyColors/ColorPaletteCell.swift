//
//  ColorPaletteCell.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/17/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

class ColorPaletteCell: BaseCell {
    
    var colorObject: UIColor? {
        didSet {
            color.backgroundColor = colorObject
        }
    }
    
    let color: UIView = {
        let cl = UIView()
        return cl
    }()

    
    override func setupViews() {
        super.setupViews()

        addSubview(color)
        
        addConstraintsWithFormat(format: "V:|[v0(70)]", views: color)
        addConstraintsWithFormat(format: "H:|[v0]|", views: color)
        
    }
}
