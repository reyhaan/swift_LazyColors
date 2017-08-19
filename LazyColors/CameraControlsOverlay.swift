//
//  CameraControlsOverlay.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/6/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

class CameraControlsOverlay: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerContainer: CameraControlsHeader = {
        let hc = CameraControlsHeader()
        return hc
    }()
    
    let colorNameContainer: ColorNameContainer = {
        let cnc = ColorNameContainer()
        return cnc
    }()
    
    func setupViews() {
        addSubview(headerContainer)
        addSubview(colorNameContainer)
        addConstraintsWithFormat(format: "V:[v0(90)]-0-[v1(40)]-0-|", views: headerContainer, colorNameContainer)
        addConstraintsWithFormat(format: "H:|[v0]|", views: headerContainer)
        addConstraintsWithFormat(format: "H:|[v0]|", views: colorNameContainer)
    }
    
}
