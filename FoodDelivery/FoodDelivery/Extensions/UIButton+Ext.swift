//
//  UIButton+Ext.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 7.08.2021.
//

import UIKit

extension UIButton{
    func setIcon(with imageString: String, title: String){
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: imageString)
        let image1String = NSAttributedString(attachment: image1Attachment)
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(image1String)
        
        
        fullString.append(NSAttributedString(string: title))
        
        setAttributedTitle(fullString, for: .normal)
    }
}
