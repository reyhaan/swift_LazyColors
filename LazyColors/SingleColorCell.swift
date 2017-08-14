//
//  SingleColorCell.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/13/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

class SingleColorCell: BaseCell {
    
    var colorObject: Color? {
        didSet {
            color.backgroundColor = UIColor(red: CGFloat((colorObject?.r)!) / 255, green: CGFloat((colorObject?.g)!) / 255, blue: CGFloat((colorObject?.b)!) / 255, alpha: 1)
            name.text = colorObject?.cmyk
            code.text = (colorObject?.rgb)! + "" + (colorObject?.hex)!
        }
    }
    
    let color: UIView = {
        let cl = UIView()
        cl.frame.size.width = 120
        return cl
    }()
    
    let name: UILabel = {
        let nm = UILabel()
        nm.frame.size.width = 120
        nm.textColor = UIColor.darkGray
        nm.padding = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 0)
        nm.font = UIFont(name: "ProximaNova-Bold", size: 12)
        return nm
    }()
    
    let code: UILabel = {
        let cd = UILabel()
        cd.frame.size.width = 120
        cd.textColor = UIColor.gray
        cd.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
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
        
        color.backgroundColor = UIColor.gray
        name.backgroundColor = UIColor.white
        code.backgroundColor = UIColor.white
        
        container.layer.cornerRadius = 5
        container.clipsToBounds = true
        container.layer.masksToBounds = true
        
        mainContainer.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        mainContainer.layer.masksToBounds = false
        mainContainer.layer.shadowColor = UIColor.lightGray.cgColor
        mainContainer.layer.shadowRadius = 3.5
        mainContainer.layer.shadowOpacity = 0.3
        
        container.addSubview(code)
        container.addSubview(name)
        container.addSubview(color)
        
        mainContainer.addSubview(container)
        
        addSubview(mainContainer)
        
        container.addConstraintsWithFormat(format: "V:|[v0(60)]-0-[v1(20)]-0-[v2(25)]|", views: color, name, code)
        container.addConstraintsWithFormat(format: "H:|[v0]|", views: color)
        container.addConstraintsWithFormat(format: "H:|[v0]|", views: name)
        container.addConstraintsWithFormat(format: "H:|[v0]|", views: code)
        
        mainContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: container)
        mainContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: container)
        
        addConstraintsWithFormat(format: "V:|-0-[v0(105)]-0-|", views: mainContainer)
        addConstraintsWithFormat(format: "H:|-0-[v0]-0-|", views: mainContainer)
        
    }
}
