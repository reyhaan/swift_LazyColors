//
//  PaletteDetail.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/27/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

class PaletteDetail: UIView {
    
    var delegate: PaletteDetailDelegate?
    
    var colorsArray: [Color]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeader()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let ccv = PaletteColorsList()
    
    let header: UIView = {
        let hd = UIView()
        hd.backgroundColor = UIColor.white
        return hd
    }()
    
    let backButton: UIView = {
        let bb = UIView()
        bb.frame = CGRect(x: 0, y: 20, width: 60, height: 50)
        return bb
    }()
    
    let backButtonView: UIButton = {
        let bb = UIButton()
        bb.contentEdgeInsets = UIEdgeInsetsMake(12, 15, 12, 15)
        bb.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        return bb
    }()
    
    let menuBarContainer: UIView = {
        let mbc = UIView()
        return mbc
    }()
    
    func setupHeader() {
        backButtonView.addTarget(self, action: #selector(self.closeColorCollectionView), for: .touchDown)
    }
    
    func closeColorCollectionView () {
        
        let appDelegate : AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        if let unwrappedAppdelegate = appDelegate {
            
            unwrappedAppdelegate.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
        
//        self.delegate?.goBackToPortal()
        
    }
    
    func setupViews() {
        
        header.backgroundColor = .white
        
        backButtonView.setImage(UIImage(named: "page_back"), for: UIControlState.normal)
        backButtonView.imageView?.contentMode = .scaleAspectFill
        
        backButton.addSubview(backButtonView)
        header.addSubview(backButton)
        header.addSubview(menuBarContainer)
        
        header.addConstraintsWithFormat(format: "V:|-(20)-[v0(50)]|", views: menuBarContainer)
        header.addConstraintsWithFormat(format: "H:[v0(140)]|", views: menuBarContainer)
        
        addSubview(header)
        addSubview(ccv)
        addConstraintsWithFormat(format: "V:|[v1(70)]-0-[v0]|", views: ccv, header)
        addConstraintsWithFormat(format: "H:|[v0]|", views: ccv)
        addConstraintsWithFormat(format: "H:|[v0]|", views: header)
    }
    
}
