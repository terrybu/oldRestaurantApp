//
//  SettingsMenuHeaderView.swift
//  Tastii
//
//  Created by Terry Bu on 12/31/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit

class SettingsMenuHeaderView: UIView {
    
    @IBOutlet var nameLabel: UILabel! 
    @IBOutlet var profileCircleImageView: UIImageView!
    
    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        print("from nib") --> yes this does get called 
        setup()
    }
    
    private func setup() {
        //don't touch imageview here coz it's not initialized yet 
    }

}
