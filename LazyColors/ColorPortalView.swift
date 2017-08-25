//
//  ColorPortalView.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/20/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

class ColorPortalView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: PreviewControllerDelegate?
    weak var delegate2: ViewControllerDelegate?
    
    var colorsArray: [Color]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pageView.register(ColorPortalCell.self, forCellWithReuseIdentifier: cellId)
        pageView.register(PalettePortalCell.self, forCellWithReuseIdentifier: paletteId)
        setupHeader()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellId = "cellId"
    let paletteId = "paletteId"
    
    lazy var pageView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let header: UIView = {
        let hd = UIView()
        hd.backgroundColor = UIColor.white
        return hd
    }()
    
    let backButton: UIView = {
        let bb = UIView()
        bb.frame = CGRect(x: 10, y: 32.5, width: 60, height: 30)
        return bb
    }()
    
    let backButtonView: UIButton = {
        let bb = UIButton()
        
        bb.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return bb
    }()
    
//    let backImageView: UIImageView = {
//        let bi = UIImageView()
//        bi.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
//        bi.image = UIImage(named: "page_back")
//        return bi
//    }()
    
    let menuBarContainer: UIView = {
        let mbc = UIView()
        return mbc
    }()
    
    lazy var portalMenuBar: PortalMenuBar = {
        let pm = PortalMenuBar()
        pm.colorPortalView = self
        return pm
    }()
    
    func setupHeader() {
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeColorCollectionView)))
        backButtonView.addTarget(self, action: #selector(self.closeColorCollectionView), for: .touchDown)
    }
    
    func closeColorCollectionView () {
        
        self.delegate?.goBackToCamera()
        
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        pageView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let index = x / self.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        portalMenuBar.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let page1 = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let page2 = collectionView.dequeueReusableCell(withReuseIdentifier: paletteId, for: indexPath)
        
        if indexPath.item == 0 {
            
            return page1
            
        } else if indexPath.item == 1 {
            
            return page2
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func setupViews() {
        
        if let flowLayout = pageView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        
        backButtonView.setImage(UIImage(named: "page_back"), for: UIControlState.normal)
        
        pageView.isPagingEnabled = true
        pageView.showsHorizontalScrollIndicator = false
        
        backButton.addSubview(backButtonView)
        header.addSubview(backButton)
        header.addSubview(menuBarContainer)
        
        menuBarContainer.addSubview(portalMenuBar)
        menuBarContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: portalMenuBar)
        menuBarContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: portalMenuBar)
        
        header.addConstraintsWithFormat(format: "V:|-(20)-[v0(50)]|", views: menuBarContainer)
        header.addConstraintsWithFormat(format: "H:[v0(140)]|", views: menuBarContainer)
        
        addSubview(header)
        addSubview(pageView)
        addConstraintsWithFormat(format: "V:|[v1(70)]-0-[v0]|", views: pageView, header)
        addConstraintsWithFormat(format: "H:|[v0]|", views: pageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: header)
    }
    
}
