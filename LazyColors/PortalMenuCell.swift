//
//  PortalMenuCell.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/20/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

class PortalMenuCell: BaseCell {
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .gray : .white
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        
    }
}
