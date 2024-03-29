//
//  ActivityTableViewCell.swift
//  Tastii
//
//  Created by Terry Bu on 12/10/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet var activityMessageTextView:UITextView!
    @IBOutlet var activityTimeCreatedLabel:UILabel!
    @IBOutlet var leftContainerView: UIView!
    @IBOutlet var rightTasteItemImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
