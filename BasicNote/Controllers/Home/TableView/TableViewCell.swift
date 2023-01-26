//
//  TableViewCell.swift
//  BasicNote
//
//  Created by Anıl AVCI on 17.01.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        dateView.layer.cornerRadius = 8
        dateView.layer.masksToBounds = true
   
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension UIView {
    public var viewWidth: CGFloat {
        return self.frame.size.width
    }

    
}
