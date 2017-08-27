//
//  ColorDetails.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/26/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class ColorDetails: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: ColorCollectionViewDelegate?
    
    public var colorDetail: Color? {
        didSet {
            colorContainer.backgroundColor = UIColor(red: CGFloat((colorDetail?.r)!) / 255, green: CGFloat((colorDetail?.g)!) / 255, blue: CGFloat((colorDetail?.b)!) / 255, alpha: 1)
            colorName.text = colorDetail?.name
        }
    }
    
    var toast: MBProgressHUD?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        colorCodeCollectionView.register(ColorCodeCell.self, forCellWithReuseIdentifier: cellId)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellId = "cellId"
    
    let mainContainer: UIView = {
        let mc = UIView()
        return mc
    }()
    
    let colorContainer: UIView = {
        let cc = UIView()
        return cc
    }()
    
    let colorName: UILabel = {
        let cn = UILabel()
        cn.font = UIFont(name: "ProximaNova-Bold", size: 16)
        cn.textColor = .darkGray
        cn.padding = UIEdgeInsets(top: 8, left: 15, bottom: 0, right: 0)
        return cn
    }()
    
    let colorDelete: UIButton = {
        let cd = UIButton()
        cd.setImage(UIImage(named: "bin"), for: .normal)
        cd.imageView?.tintColor = .lightGray
        return cd
    }()
    
    let colorShare: UIButton = {
        let cs = UIButton()
        cs.setImage(UIImage(named: "email"), for: .normal)
        cs.imageView?.tintColor = .black
        return cs
    }()
    
    let colorOptions: UIView = {
        let co = UIView()
        return co
    }()
    
    let colorCodeListContainer: UIView = {
        let ccl = UIView()
        return ccl
    }()
    
    
    lazy var colorCodeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // EMAIL STUFF ====================
    
    func sendEmailButtonTapped(sender: AnyObject) {
    
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            
            let appDelegate : AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            if let unwrappedAppdelegate = appDelegate {
                
                unwrappedAppdelegate.window!.rootViewController!.present(mailComposeViewController, animated: true, completion: nil)
                unwrappedAppdelegate.window!.exchangeSubview(at: 0, withSubviewAt: 1)
            }
            
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        let appDelegate : AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        if let unwrappedAppdelegate = appDelegate {
            unwrappedAppdelegate.window!.exchangeSubview(at: 1, withSubviewAt: 0)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setSubject("Color you might like")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        showToast(msg: "Could not send email, please try again!")
    }
    
     // ====================================
    
    func showToast(msg: String) {
        toast = MBProgressHUD.showAdded(to: self, animated: true)
        toast?.show(animated: true)
        toast?.mode = MBProgressHUDMode.text
        toast?.margin = 10
        toast?.offset.y = (self.frame.height / 2) - 100
        toast?.label.textColor = .black
        toast?.label.font = UIFont(name: "ProximaNova-Regular", size: 14)
        toast?.removeFromSuperViewOnHide = true
        toast?.label.text = msg
        toast?.hide(animated: true, afterDelay: 2)
    }
    
    func deleteColor() {
        let delegate = (UIApplication.shared.delegate as? AppDelegate)
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest: NSFetchRequest<Color> = Color.fetchRequest()
            do {
                
                let something: [Color] = try context.fetch(fetchRequest)
                
                for object in something {
                    if object.objectID == (colorDetail?.objectID)! {
                        context.delete(object)
                    }
                }
                
                do {
                    try context.save() // <- remember to put this :)
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
                        self.superview?.alpha = 0
                        self.superview?.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
                    }, completion: {(f) -> Void in
                        self.superview?.removeFromSuperview()
                        self.delegate?.reloadData()
                    })
                    
                } catch {
                    // Do something... fatalerror
                }
                
            } catch let err {
                
                print(err)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorCodeCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ColorCodeCell
        
        if indexPath.item == 0 {
            
            cell.type = "RGB"
            cell.value = "\((colorDetail?.rgb)!)"
            
        } else if indexPath.item == 1 {
            
            cell.type = "HEX"
            cell.value = "#\((colorDetail?.hex)!)"
            
        } else if indexPath.item == 2 {
            
            cell.type = "CMYK"
            cell.value = "\((colorDetail?.cmyk)!)"
            
            
        } else if indexPath.item == 3 {
            
            cell.type = "HSL"
            cell.value = "\((colorDetail?.hsl)!)"
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width / 2) - 20, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            
            print(colorDetail?.objectID)
            
            UIPasteboard.general.string = "\((colorDetail?.rgb)!)"
            showToast(msg: "Copied")
            
            
        } else if indexPath.item == 1 {
            
            UIPasteboard.general.string = "#\((colorDetail?.hex)!)"
            showToast(msg: "Copied")
            
        } else if indexPath.item == 2 {
            
            UIPasteboard.general.string = "\((colorDetail?.cmyk)!)"
            showToast(msg: "Copied")
            
            
        } else if indexPath.item == 3 {
            
            UIPasteboard.general.string = "\((colorDetail?.hsl)!)"
            showToast(msg: "Copied")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    }
    
    func setupViews() {
        
        mainContainer.addSubview(colorContainer)
        mainContainer.addSubview(colorName)
        mainContainer.addSubview(colorOptions)
        mainContainer.addSubview(colorCodeListContainer)
        
        colorCodeListContainer.addSubview(colorCodeCollectionView)
        colorCodeListContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: colorCodeCollectionView)
        colorCodeListContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: colorCodeCollectionView)
        
        mainContainer.addSubview(colorDelete)
        mainContainer.addSubview(colorShare)
        
        colorShare.addTarget(self, action: #selector(self.sendEmailButtonTapped), for: .touchDown)
        colorDelete.addTarget(self, action: #selector(self.deleteColor), for: .touchDown)

        colorDelete.topAnchor.constraint(equalTo: colorContainer.bottomAnchor, constant: 30).isActive = true
        colorShare.topAnchor.constraint(equalTo: colorContainer.bottomAnchor, constant: 30).isActive = true
        mainContainer.addConstraintsWithFormat(format: "H:[v1(45)]-0-[v0(50)]|", views: colorDelete, colorShare)
        
        mainContainer.addConstraintsWithFormat(format: "V:|[v0(200)]-15-[v1(40)]-15-[v2(200)]", views: colorContainer, colorName, colorCodeListContainer)
        mainContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: colorContainer)
        mainContainer.addConstraintsWithFormat(format: "H:|[v0(210)]", views: colorName)
        mainContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: colorCodeListContainer)
        
        addSubview(mainContainer)
        addConstraintsWithFormat(format: "V:|[v0]|", views: mainContainer)
        addConstraintsWithFormat(format: "H:|[v0]|", views: mainContainer)
        
    }
    
}
