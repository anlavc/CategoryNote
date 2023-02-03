//
//  UIView + Ext.swift
//  BasicNote
//
//  Created by Anıl AVCI on 4.02.2023.
//

import UIKit
extension UIView {
    
    func addBottomBorderLineWithColor(color: UIColor, width: CGFloat) {
        let bottomBorderLine = CALayer()
        bottomBorderLine.cornerRadius = 5
        bottomBorderLine.backgroundColor = color.cgColor
        bottomBorderLine.frame = CGRect(x: 0,y: self.frame.size.height
    
        - width,width: self.frame.size.width, height: width)
        self.layer.addSublayer(bottomBorderLine)
    }
}
