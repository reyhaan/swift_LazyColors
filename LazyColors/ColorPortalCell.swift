//
//  ColorPortalCell.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/20/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

class ColorPortalCell: BaseCell {
    
    let colorList: ColorCollectionView = {
        let cl = ColorCollectionView()
        return cl
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(colorList)
        
        addConstraintsWithFormat(format: "V:|-(40)-[v0]-(40)-|", views: colorList)
        addConstraintsWithFormat(format: "H:|[v0]|", views: colorList)
        
    }
}
