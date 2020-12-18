//
//  AppColors.swift
//  template-ios
//
//  Created by John Paulo on 4/21/20.
//

import UIKit


extension UIColor {
    open class var baseColor: UIColor {
        return UIColor(named: "Base Color")!
    }
    
    open class var accentColor: UIColor {
        return UIColor(named: "Accent Color")!
    }
    
    open class var baseButtonTextColor: UIColor {
        return UIColor(named: "Base Button Text Color")!
    }
    
    open class var baseCellBackgroundColor: UIColor {
        return UIColor(named: "Base Cell Background Color")!
    }
    
    open class var headerBackgroundColor: UIColor {
        return UIColor(named: "Header Background Color")!
    }
    
    // NOTE: Should be a good idea to also set a default text color
    // so we can modify its color for dark mode. But for now,
    // the default system text color is acceptable
}
