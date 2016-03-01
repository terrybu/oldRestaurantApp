//
//  UIViewExtension.swift
//  Tastii
//
//  Created by Terry Bu on 12/31/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
}
