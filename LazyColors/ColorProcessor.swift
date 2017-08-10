//
//  ColorProcessor.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/10/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    var redValue: Int16{ return Int16(CIColor(color: self).red * 255) }
    var greenValue: Int16{ return Int16(CIColor(color: self).green * 255) }
    var blueValue: Int16{ return Int16(CIColor(color: self).blue * 255) }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
    
    func getName() -> String {
        let hexVal = getHex()
        if (HexColorNames[hexVal] != nil) {
            return HexColorNames[hexVal]!
        } else {
            return "nil"
        }
    }
    
    func getNameUsingRgb() -> String {
        
//        let rgbVal = getRgb()
//        
//        if (RgbColorNames[rgbVal] != nil) {
//            return RgbColorNames[rgbVal]!
//        } else {
//            return "nil"
//        }
        
        return ""
    }
    
    func getHex() -> String {
        let r = String(format:"%02X", self.redValue)
        let g = String(format:"%02X", self.greenValue)
        let b = String(format:"%02X", self.blueValue)
        
        return "\(r)\(g)\(b)"
    }
    
    func getRgb() -> String {
        return "(\(self.redValue), \(self.greenValue), \(self.blueValue))"
    }
    
    func getHsb() {
        
    }
    
    func getCmyk() {
        
    }
    
    func getShades() {
        
    }
    
}

extension CameraControlsHeader {
    func getColorDetails(color: UIColor) -> Int16 {
        return color.redValue
    }
}
