//
//  TastiiTabBarViewController.swift
//  Tastii
//
//  Created by Terry Bu on 10/21/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit

class TastiiTabBarViewController: UITabBarController {
        
    var button: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor(rgba: "#ff5755")
    }
    
    func removeTabbarItemText() {
        if let items = tabBar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

