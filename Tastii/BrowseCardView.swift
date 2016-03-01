//
//  BrowseCardView.swift
//  Tastii
//
//  Created by Terry Bu on 12/17/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit

@IBDesignable class BrowseCardView: UIView {

    @IBOutlet var foodItemImageView: UIImageView!
    
    @IBAction func detailsButtonPressed() {
        print("details button pressed")
    }
    
    
    //MARK: Lifecycle
    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.layer.borderWidth = 1.0 //this sets the border width for the cards
        
    }
    
}
