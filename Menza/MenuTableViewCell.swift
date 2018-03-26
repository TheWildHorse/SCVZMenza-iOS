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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let fixedWidth = MenuDescriptionLabel.frame.size.width
        MenuDescriptionLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = MenuDescriptionLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = MenuDescriptionLabel.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        MenuDescriptionLabel.frame = newFrame;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MenuDescriptionLabel.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
