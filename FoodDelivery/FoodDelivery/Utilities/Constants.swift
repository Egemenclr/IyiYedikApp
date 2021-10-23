//
//  Constants.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 1.08.2021.
//

import UIKit

// SF Symbols
enum SFSymbols{
    static let order            = UIImage(named: "order")
    static let magnifyingglass  = UIImage(systemName: "magnifyingglass")
    static let cart             = UIImage(systemName: "cart")
    static let basket           = UIImage(named: "basket")
    static let bookmark         = UIImage(systemName: "bookmark")
    
    static let profile          = UIImage(systemName: "person.circle")
    static let airpods          = UIImage(systemName: "airpods")
    
    static let eye              = UIImage(systemName: "eye")
    static let eyeSlash         = UIImage(systemName: "eye.slash")
    
    static let phone    = UIImage(systemName: "phone")
    static let map      = UIImage(systemName: "map")
    
    static let hand     = UIImage(systemName: "hand.thumbsup")
    static let handFill = UIImage(systemName: "hand.thumbsup.fill")
    static let trash    = UIImage(systemName: "trash")
    
}

// Fonts
enum Fonts{
    static let helvetica        = UIFont(name: "Helvetica", size: 14)
    static let helvetica_bold   = UIFont(name: "HelveticaNeue-Bold", size: 14)
}

enum Images{
    static let emptyBasket = UIImage(named: "emptyBasket")
}

enum Colors{
    static let grey10 = hexStringToUIColor(hex: "EAE9EB")
}

func hexStringToUIColor (hex:String) -> UIColor {
    
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

