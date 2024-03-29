//
//  ColorNameContainer.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/13/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

class ColorNameContainer: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let name: UILabel = {
        let nm = UILabel()
        nm.textAlignment = NSTextAlignment.center
        nm.textColor = UIColor.white
        nm.padding = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        nm.font = UIFont(name: "ProximaNova-Regular", size: 14)
        return nm
    }()
    
    let code: UILabel = {
        let cd = UILabel()
        cd.textAlignment = NSTextAlignment.center
        cd.textColor = UIColor.white
        cd.font = UIFont(name: "ProximaNova-Regular", size: 12)
        return cd
    }()
    
    func setupViews() {
        addSubview(name)
        addSubview(code)
        addConstraintsWithFormat(format: "V:[v1(25)]-0-[v0(25)]|", views: code, name)
        addConstraintsWithFormat(format: "H:|[v0]|", views: name)
        addConstraintsWithFormat(format: "H:|[v0]|", views: code)
    }
    
}
