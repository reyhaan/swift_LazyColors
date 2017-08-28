//
//  PaletteColorsList.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/27/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

protocol PaletteColorsListDelegate {
    func reloadData(object: Any?)
}

class PaletteColorsList: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PaletteColorsListDelegate {
    
    weak var delegate: PreviewControllerDelegate?
    weak var delegate2: ViewControllerDelegate?
    
    var colorsArray: [Color]?
    
    var selectedPalette: Palette?
    
    var waveView: WXWaveView?
    
    var clickedCell: UICollectionViewCell?
    
    var scrollOffsetY: CGFloat = 0
    
    var waveNotApplied: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        colorCollectionView.register(SingleColorCell.self, forCellWithReuseIdentifier: cellId)
        setupViews()
        setupInfoOverlay()
        
        cd.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData(object: Any?) {
        
        colorsArray = colorsArray?.filter {$0 != object as? Color}
        
        colorCollectionView.reloadData()
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
    
    // Cel info stuff
    
    let cellInfoOverlay: UIView = {
        let ci = UIView()
        ci.alpha = 0
        ci.backgroundColor = .white
        return ci
    }()
    
    let infoCloseButton: UIButton = {
        let cb = UIButton()
        cb.setImage(UIImage(named: "page_back_white"), for: .normal)
        cb.titleLabel?.backgroundColor = .gray
        return cb
    }()
    
    let cd = PaletteColorDetails()
    
    func setupInfoOverlay() {
        infoCloseButton.addTarget(self, action: #selector(self.closeOverlay), for: .touchDown)
        infoCloseButton.frame = CGRect(x: 10, y: 20, width: 40, height: 40)
        cellInfoOverlay.addSubview(infoCloseButton)
        
    }
    
    func closeOverlay() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
            self.cellInfoOverlay.alpha = 0
            self.cellInfoOverlay.frame = (self.clickedCell?.frame)!
            self.cellInfoOverlay.frame.origin.y = ((self.clickedCell?.frame.origin.y)! - self.scrollOffsetY) + 60
        }, completion: {(f) -> Void in
            self.cellInfoOverlay.removeFromSuperview()
        })
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollOffsetY = targetContentOffset.pointee.y
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        clickedCell = colorCollectionView.cellForItem(at: indexPath)
        clickedCell?.superview?.bringSubview(toFront: clickedCell!)
        cellInfoOverlay.frame = (clickedCell?.frame)!
        cellInfoOverlay.frame.origin.y = cellInfoOverlay.frame.origin.y - self.scrollOffsetY
        
        if let window = UIApplication.shared.keyWindow {
            
            var preferredStatusBarStyle: UIStatusBarStyle {
                return .lightContent
            }
            
            cd.backgroundColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
            cd.colorDetail = colorsArray?[indexPath.item]
            cellInfoOverlay.addSubview(cd)
            cellInfoOverlay.bringSubview(toFront: infoCloseButton)
            cd.colorCodeCollectionView.reloadData()
            cellInfoOverlay.addConstraintsWithFormat(format: "V:|[v0]|", views: cd)
            cellInfoOverlay.addConstraintsWithFormat(format: "H:|[v0]|", views: cd)
            
            window.addSubview(cellInfoOverlay)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
                self.cellInfoOverlay.alpha = 1
                self.cellInfoOverlay.frame = window.bounds
                
            }, completion: {(f) -> Void in
                
                if self.waveNotApplied {
                    self.waveView = WXWaveView.add(to: self.cd.colorContainer, withFrame: CGRect(x: 0, y: self.cd.colorContainer.frame.size.height - 5, width: self.cd.colorContainer.frame.width, height: 5))
                    // Optional Setting
                    self.waveView?.waveTime = 0;     // When 0, the wave will never stop;
                    self.waveView?.waveColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
                    self.waveView?.waveSpeed = 5;
                    self.waveView?.angularSpeed = 1.8;
                    self.waveView?.wave()
                    self.waveNotApplied = false
                }
            })
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = colorsArray?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SingleColorCell
        
        if let color = colorsArray?[indexPath.item] {
            if color.name != nil {
                cell?.colorObject = color
            }
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 2 - 20, height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func setupViews() {
        
        addSubview(colorCollectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: colorCollectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: colorCollectionView)
    }
    
}

