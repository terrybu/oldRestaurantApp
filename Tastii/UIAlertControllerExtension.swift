//
//  UIAlertControllerExtension.swift
//  Tastii-ClosedBetaTesting
//
//  Created by Terry Bu on 1/22/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func presentAlert(viewController: UIViewController, alertTitle: String, alertMessage: String, confirmTitle: String) {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let confirm = UIAlertAction(title: confirmTitle, style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(confirm)
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
}