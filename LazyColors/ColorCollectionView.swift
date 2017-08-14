//
//  ColorCollectionView.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/13/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

class ColorCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: ViewControllerDelegate?
    
    var colorsArray: [Color]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        colorCollectionView.register(SingleColorCell.self, forCellWithReuseIdentifier: cellId)
        setupHeader()
        setupViews()
//        loadData()
//        clearData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellId = "cellId"
    
    lazy var colorCollectionView: UICollectionView = {
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
    
    func setupHeader() {
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeColorCollectionView)))
    }
    
    func closeColorCollectionView () {
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: {
                    window.subviews[1].frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height)
            },
                completion: nil
            )
            
            self.delegate?.unfreezeFrame()

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = colorsArray?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SingleColorCell
        
//        cell?.backgroundColor = UIColor.orange
        
        if let color = colorsArray?[indexPath.item] {
            cell?.colorObject = color
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 2 - 17, height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func setupViews() {
        addSubview(header)
        addSubview(colorCollectionView)
        addConstraintsWithFormat(format: "V:|[v1(70)]-0-[v0]|", views: colorCollectionView, header)
        addConstraintsWithFormat(format: "H:|[v0]|", views: colorCollectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: header)
    }
    
}
