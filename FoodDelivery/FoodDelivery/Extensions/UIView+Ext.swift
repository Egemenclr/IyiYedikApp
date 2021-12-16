//
//  UIView+Ext.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 15.12.2021.
//

import UIKit

extension UIView {
    func alignFitEdges(padding: CGFloat = 0.0) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor, constant: padding),
            leadingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ]
    }
}
