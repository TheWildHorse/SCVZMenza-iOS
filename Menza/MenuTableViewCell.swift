//
//  MenuTableViewCell.swift
//  Menza
//
//  Created by Igor Rinkovec on 08/05/16.
//  Copyright © 2016 Igor Rinkovec. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var MenuDescriptionLabel: UILabel!
    @IBOutlet weak var MenuImageIcon: UIImageView!
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let fixedWidth = MenuDescriptionLabel.frame.size.width
        MenuDescriptionLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = MenuDescriptionLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = MenuDescriptionLabel.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        MenuDescriptionLabel.frame = newFrame;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MenuDescriptionLabel.addObserver(self, forKeyPath: "text", options: [.Old, .New], context: nil)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
