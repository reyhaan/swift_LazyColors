//
//  ColorPaletteView.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/16/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

class ColorPaletteView: UIView {
    
    weak var delegate: ViewControllerDelegate?
    
    var palette: Array<UIColor>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setupViews()
    }
    
    let parentContainer: UIView = {
        let pc = UIView()
        pc.backgroundColor = UIColor.red
        return pc
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupViews() {
        addSubview(parentContainer)
        addConstraintsWithFormat(format: "V:|[v0(140)]", views: parentContainer)
        addConstraintsWithFormat(format: "H:|[v0]|", views: parentContainer)
    }
}

