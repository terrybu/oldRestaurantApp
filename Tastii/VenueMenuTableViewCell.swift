//
//  VenueMenuTableViewCell.swift
//  Tastii
//
//  Created by Terry Bu on 1/28/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

class VenueMenuTableViewCell: UITableViewCell {
    @IBOutlet var menuItemNameLabel: UILabel!
    @IBOutlet var menuItemDescriptionLabel: UILabel!
    @IBOutlet var menuItemPriceDistanceLabel: UILabel!
    @IBOutlet var firstCircleImageView: UIImageView!
    @IBOutlet var secondCircleImageView: UIImageView!
    @IBOutlet var thirdCircleImageView: UIImageView!
    @IBOutlet var itemsDetailsButton: UIButton! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None
        firstCircleImageView.circleImageViewSetUp(UIColor(rgba: "#ff6b69"))
        secondCircleImageView.circleImageViewSetUp(UIColor(rgba: "#ff6b69"))
        thirdCircleImageView.circleImageViewSetUp(UIColor(rgba: "#ff6b69"))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    
    
}
