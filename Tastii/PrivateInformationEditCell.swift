//
//  PrivateInformationEditCell.swift
//  Tastii
//
//  Created by Terry Bu on 1/13/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

class PrivateInformationEditCell: UITableViewCell {
    
    @IBOutlet var editInfoTextField: UITextField!
    @IBOutlet var actionButton: UIButton!
    var didTapButtonBlock: ((sender: AnyObject) -> Void)?
    
    var hideActionButton: Bool = false {
        didSet {
            if hideActionButton == true {
                actionButton.hidden = true
                actionButton.enabled = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        actionButton.addTarget(self, action: "didTapButton:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func didTapButton(sender: AnyObject) {
        if let buttonTapBlock = self.didTapButtonBlock {
            buttonTapBlock(sender: sender)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
