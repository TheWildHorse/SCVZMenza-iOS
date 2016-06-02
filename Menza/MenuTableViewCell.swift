//
//  MenuTableViewCell.swift
//  Menza
//
//  Created by Igor Rinkovec on 08/05/16.
//  Copyright © 2016 Igor Rinkovec. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var MenuNameLabel: UILabel!
    @IBOutlet weak var MenuDescriptionLabel: UILabel!
    @IBOutlet weak var MenuImageIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
