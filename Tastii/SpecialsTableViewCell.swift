//
//  SpecialsTableViewCell.swift
//  Tastii
//
//  Created by Terry Bu on 12/28/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit
import TagListView

class SpecialsTableViewCell: MyMenuTableViewCell {
    
    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var blackOverlayOverBackImageView: UIView!
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
