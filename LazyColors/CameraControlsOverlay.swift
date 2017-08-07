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
        backgroundColor = UIColor.clear
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let footerContainer: CameraControlsFooter = {
        let fc = CameraControlsFooter()
        return fc
    }()
    
    let headerContainer: CameraControlsHeader = {
        let hc = CameraControlsHeader()
        return hc
    }()
    
    func setupViews() {
        addSubview(headerContainer)
        addSubview(footerContainer)
        addConstraintsWithFormat(format: "V:[v1(90)]-0-[v0(50)]-(-50)-|", views: footerContainer, headerContainer)
        addConstraintsWithFormat(format: "H:|[v0]|", views: footerContainer)
        addConstraintsWithFormat(format: "H:|[v0]|", views: headerContainer)
    }
    
}
