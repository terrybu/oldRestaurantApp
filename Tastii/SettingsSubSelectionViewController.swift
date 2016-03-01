//
//  SettingsSubSelectionViewController.swift
//  Tastii
//
//  Created by Terry Bu on 1/7/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

class SettingsSubSelectionViewController: UIViewController {

    weak var tastiiTabBarViewController: TastiiTabBarViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Dosis-Medium", size: 21)!]
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
