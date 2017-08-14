//
//  ViewControllerExtension.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/13/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

extension ViewController {
    
    func getUIImage(image: CIImage) -> UIImage {
        let image2: CIImage = image
        let image3: CGImage = {
            return ciContext.createCGImage(image2, from: image2.extent)!
        }()
        return UIImage(cgImage: image3)
    }
    
    func applyFilter(image: CIImage, name: String) -> UIImage {
        // 1
        let originalImage = image
        var ouputImage: CIImage?
        
        switch name {
        case "sepia":
            // define filter here
            let filter = CIFilter(name: "CIPhotoEffectMono")
            filter?.setDefaults()
            filter?.setValue(originalImage, forKey: kCIInputImageKey)
            ouputImage = filter?.outputImage
            break
        default:
            // handle default case
            
            break
        }
        
        let newImage = getUIImage(image: ouputImage!)
        
        return newImage
        
    }
    
    func cropImage (image: CIImage, touchX: CGFloat, touchY: CGFloat) -> UIImage {
        let CropBoxHeight = CGFloat(10)
        let CropBoxWidth = CGFloat(10)
        
        // fix orientation of image
        var inputCiImage = image
        inputCiImage = inputCiImage.applyingOrientation(6)
        
        // actual image size and screen size is different, so scale the touch points to match image size cordinates
        let img = UIImage(ciImage: inputCiImage)
        let scaleFactorY = img.size.height / view.frame.height
        let scaleFactorX = img.size.width / view.frame.width
        
        // apply cropping
        let croppedImage = inputCiImage.cropping(to: CGRect(x: touchX * scaleFactorX, y: ((view.frame.height * scaleFactorY) - (touchY * scaleFactorY)), width: CropBoxWidth, height: CropBoxHeight))
        
        let cgImage = ciContext.createCGImage(croppedImage, from: (croppedImage.extent))
        return UIImage(cgImage: cgImage!)
    }
    
    func updateColorPreview (image: UIImage) {
        let dominantColor = image.dominantColors()
        self.color = dominantColor[0]
        let collectionView = self.cameraButtons.headerContainer.headerCollectionView
        let cell = collectionView.cellForItem(at: IndexPath(item: 1, section: 0))
        
        let colorNameView = self.cameraButtons.colorNameContainer
        
        DispatchQueue.main.async() {
            //            colorNameView.name.text = self.color?.getName()[1] as? String
            //            colorNameView.code.font = UIFont(name: "ProximaNovaRegular", size: 5)
            colorNameView.code.text = "#" + (self.color?.getHex())!
        }

        cell?.subviews[1].backgroundColor = self.color
        cell?.subviews[1].setNeedsLayout()
    }
    
    func generateLivePreview() {
        // update UI asynchronously
        DispatchQueue.main.async() {
            // Apply filter to crop it here
            let image = self.cropImage(image: self.ciImage!, touchX: self.touchX!, touchY: self.touchY!)
            self.updateColorPreview(image: image)
        }
    }
    
}
