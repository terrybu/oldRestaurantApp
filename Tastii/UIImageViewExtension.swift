//
//  UIImageViewExtension.swift
//  Tastii
//
//  Created by Terry Bu on 12/30/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func circleImageViewSetUp(borderColor: UIColor) {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 2.0
        self.layer.borderColor = borderColor.CGColor
    }
    
    func makeImageViewTappableWithAction(imageView: UIImageView, selector: Selector, delegate: UIGestureRecognizerDelegate) {
        imageView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: delegate, action: selector)
        tapGesture.delegate = delegate
        imageView.addGestureRecognizer(tapGesture)
    }
}

