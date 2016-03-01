//
//  MenuItemTableViewCell.swift
//  Tastii
//
//  Created by Terry Bu on 12/30/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit
import TagListView

class MenuItemTableViewCell: MyMenuTableViewCell {
    
    @IBOutlet var detailsButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
