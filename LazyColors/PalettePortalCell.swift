//
//  PalettePortalCell.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/20/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

class PalettePortalCell: BaseCell {
    
    let paletteList: PaletteCollectionView = {
        let cl = PaletteCollectionView()
        return cl
    }()
    
    override func setupViews() {
        super.setupViews()
        
        print("palette reloaded!===========================")

        addSubview(paletteList)
        
        addConstraintsWithFormat(format: "V:|-(40)-[v0]-(40)-|", views: paletteList)
        addConstraintsWithFormat(format: "H:|[v0]|", views: paletteList)
        
    }
}
