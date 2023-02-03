//
//  CollectionViewCell.swift
//  BasicNote
//
//  Created by Anıl AVCI on 15.01.2023.
//

import UIKit
import CoreData

class CategoryCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var deleteIcon: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       // contentView.backgroundColor = .random()
//        let blurEfect = UIBlurEffect(style: .light)
//        let blurEffectView = UIVisualEffectView(effect: blurEfect)
//        blurEffectView.frame = contentView.bounds
//        contentView.addSubview(blurEffectView)
//        contentView.addSubview(categoryLabel)
        
        contentView.layer.cornerRadius = frame.height / 5
        contentView.layer.masksToBounds = true
        
    }
    

}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 0.3
        )
    }
}





