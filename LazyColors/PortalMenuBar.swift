//
//  PortalMenuBar.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/20/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

class PortalMenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        menuBarCollectionView.register(PortalMenuCell.self, forCellWithReuseIdentifier: cellId)
        setupViews()
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        menuBarCollectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .left)
        
    }
    
    var colorPortalView: ColorPortalView?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellId = "cellId"
    
    lazy var menuBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PortalMenuCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 2, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        colorPortalView?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
    func setupViews() {
        
        if let flowLayout = menuBarCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        
        menuBarCollectionView.isPagingEnabled = true
        menuBarCollectionView.showsHorizontalScrollIndicator = false
        
        addSubview(menuBarCollectionView)
        addConstraintsWithFormat(format: "V:|[v0(50)]|", views: menuBarCollectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuBarCollectionView)
    }
    
}
