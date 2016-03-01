//
//  MyMenuTableViewCell.swift
//  Tastii
//
//  Created by Terry Bu on 12/30/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit
import TagListView

class MyMenuTableViewCell: UITableViewCell {

    @IBOutlet var tagListView: TagListView!
    var tagsDone: Bool = false
    @IBOutlet var menuItemNameLabel: UILabel!
    @IBOutlet var menuItemDescriptionLabel: UILabel!
    @IBOutlet var menuItemPriceDistanceLabel: UILabel!
    @IBOutlet var firstCircleImageView: UIImageView!
    @IBOutlet var secondCircleImageView: UIImageView!
    @IBOutlet var thirdCircleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagListView.textFont = UIFont.systemFontOfSize(16)
        tagListView.alignment = .Center
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        firstCircleImageView.circleImageViewSetUp(UIColor(rgba: "#ff6b69"))
        secondCircleImageView.circleImageViewSetUp(UIColor(rgba: "#ff6b69"))
        thirdCircleImageView.circleImageViewSetUp(UIColor(rgba: "#ff6b69"))
        //dummy exception but making third circle imageview gray border
        thirdCircleImageView.layer.borderColor = UIColor.grayColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
