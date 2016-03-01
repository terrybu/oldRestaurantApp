//
//  TastiiPaddedTextField.swift
//  Tastii
//
//  Created by Terry Bu on 10/8/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

class TastiiPaddedTextField: UITextField {
    
    var paddedLeftView: UIView!
    var bottomBorder: CALayer?
    var activateLeftViewPadding: Bool {
        didSet {
            paddedLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
            self.leftViewMode = UITextFieldViewMode.Always
            self.leftView = paddedLeftView
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    required init(coder aDecoder: NSCoder) {
        activateLeftViewPadding = false
        super.init(coder: aDecoder)!
        
        bottomBorder = CALayer()
        bottomBorder!.frame = CGRectMake(0.0, self.frame.size.height - 1, self.frame.size.width, 1.0);
        bottomBorder!.backgroundColor = UIColor(red:
            208/255.0, green: 208/255.0, blue: 208/255.0, alpha: 1.0).CGColor
        self.layer.addSublayer(bottomBorder!)
    }
    
    func addImageIcon(imageName: String) {
        let iconImgView = UIImageView(image: UIImage(named: imageName))
        iconImgView.contentMode = UIViewContentMode.ScaleAspectFit
        iconImgView.clipsToBounds = true
        iconImgView.frame = CGRect(x: 12, y: 5, width: 30, height: 19)
        self.paddedLeftView.addSubview(iconImgView)
    }
    
}