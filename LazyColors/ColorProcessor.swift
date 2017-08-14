//
//  ColorProcessor.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/10/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit
import Foundation
import JavaScriptCore

extension UIColor {
    var redValue: Int16{ return Int16(CIColor(color: self).red * 255) }
    var greenValue: Int16{ return Int16(CIColor(color: self).green * 255) }
    var blueValue: Int16{ return Int16(CIColor(color: self).blue * 255) }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
    
    func getName() -> Array<Any> {
        
        let jsContext = JSContext()
        
        let color = getHex()
        
        var name: JSValue?
        
        // Specify the path to the jssource.js file.
        if let jsSourcePath = Bundle.main.path(forResource: "ntc", ofType: "js") {
            do {
                // Load its contents to a String variable.
                let ntc_lib = try String(contentsOfFile: jsSourcePath)
                
                // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
                _ = jsContext?.evaluateScript(ntc_lib)
                let fn = jsContext?.objectForKeyedSubscript("ntc")
                name = fn?.invokeMethod("name", withArguments: [color])

            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        return (name?.toArray())!
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
    
    func getHsl() -> Array<Any> {
        let jsContext = JSContext()
        
        let color = getHex()
        
        var hsl: JSValue?
        
        // Specify the path to the jssource.js file.
        if let jsSourcePath = Bundle.main.path(forResource: "ntc", ofType: "js") {
            do {
                // Load its contents to a String variable.
                let ntc_lib = try String(contentsOfFile: jsSourcePath)
                
                // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
                _ = jsContext?.evaluateScript(ntc_lib)
                let fn = jsContext?.objectForKeyedSubscript("ntc")
                hsl = fn?.invokeMethod("hsl", withArguments: [color])
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        return (hsl?.toArray())!
    }
    
    func getCmyk() -> Array<Any> {
        let jsContext = JSContext()
        
//        let color = getHex()
        
        var cmyk: JSValue?
        
        // Specify the path to the jssource.js file.
        if let jsSourcePath = Bundle.main.path(forResource: "ntc", ofType: "js") {
            do {
                // Load its contents to a String variable.
                let ntc_lib = try String(contentsOfFile: jsSourcePath)
                
                // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
                _ = jsContext?.evaluateScript(ntc_lib)
                let fn = jsContext?.objectForKeyedSubscript("ntc")
                cmyk = fn?.invokeMethod("cmyk2", withArguments: [self.redValue, self.greenValue, self.blueValue])
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        return (cmyk?.toArray())!
    }
    
    func getShades() {
        
    }
    
}

extension CameraControlsHeader {
    func getColorDetails(color: UIColor) -> Int16 {
        return color.redValue
    }
}
