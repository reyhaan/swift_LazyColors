//
//  ColorCodeCell.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/26/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

class ColorCodeCell: BaseCell {
    
    var type: String? {
        didSet {
            name.text = type
        }
    }
    
    var value: String? {
        didSet {
            code.text = value
        }
    }
    
    let code: UILabel = {
        let nm = UILabel()
        nm.frame.size.width = 120
        nm.textAlignment = .center
        nm.textColor = UIColor.darkGray
        nm.padding = UIEdgeInsets(top: 14, left: 0, bottom: 0, right: 0)
        nm.font = UIFont(name: "ProximaNova-Bold", size: 12)
        return nm
    }()
    
    let name: UILabel = {
        let cd = UILabel()
        cd.frame.size.width = 120
        cd.textAlignment = .center
        cd.textColor = UIColor.lightGray
        cd.padding = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        cd.font = UIFont(name: "ProximaNova-Regular", size: 10)
        return cd
    }()
    
    let container: UIView = {
        let cn = UIView()
        return cn
    }()
    
    let mainContainer: UIView = {
        let cn = UIView()
        return cn
    }()
    
    override func setupViews() {
        super.setupViews()
        
        name.backgroundColor = UIColor.white
        code.backgroundColor = UIColor.white
        
        container.layer.cornerRadius = 5
        container.clipsToBounds = true
        container.layer.masksToBounds = true
        
        mainContainer.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        mainContainer.layer.masksToBounds = false
        mainContainer.layer.shadowColor = UIColor.lightGray.cgColor
        mainContainer.layer.shadowRadius = 2
        mainContainer.layer.shadowOpacity = 0.6
        
        container.addSubview(code)
        container.addSubview(name)
        
        mainContainer.addSubview(container)
        
        addSubview(mainContainer)
        
        container.addConstraintsWithFormat(format: "V:|[v0(30)]-0-[v1(35)]|", views: code, name)
        container.addConstraintsWithFormat(format: "H:|[v0]|", views: code)
        container.addConstraintsWithFormat(format: "H:|[v0]|", views: name)
        
        mainContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: container)
        mainContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: container)
        
        addConstraintsWithFormat(format: "V:|-0-[v0(65)]-0-|", views: mainContainer)
        addConstraintsWithFormat(format: "H:|-0-[v0]-0-|", views: mainContainer)
        
    }
}

