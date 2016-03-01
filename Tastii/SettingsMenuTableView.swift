//
//  SettingsMenuTableView.swift
//  Tastii
//
//  Created by Terry Bu on 12/22/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit

class SettingsMenuTableView: UITableView {
    
    var showing: Bool
    
    override init(frame: CGRect, style: UITableViewStyle) {
        showing = false
        super.init(frame: frame, style: style)
    }
    
    required init(coder aDecoder: NSCoder) {
        showing = false
        super.init(coder: aDecoder)!
    }
    
    
}
