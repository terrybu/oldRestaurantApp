//
//  TealSwitch.swift
//  Tastii
//
//  Created by Terry Bu on 1/28/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

class TealSwitch: UISwitch {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.onTintColor = UIColor(rgba: "#55eace")
        self.transform = CGAffineTransformMakeScale(0.75, 0.75);
    }

}
