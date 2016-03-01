//
//  UserProfileTableViewCell.swift
//  Tastii
//
//  Created by Terry Bu on 2/17/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var wantOrLoveLabel: UILabel!
    @IBOutlet weak var statNumLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
