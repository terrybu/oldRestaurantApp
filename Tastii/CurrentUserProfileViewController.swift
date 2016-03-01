//
//  CurrentUserProfileViewController
//  Tastii
//
//  Created by Terry Bu on 2/10/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

class CurrentUserProfileViewController: ProfileParentViewController{
    
    @IBOutlet weak var addMenuButton: UIButton!
    var blackOverlayLeftView: UIView!
    var settingsMenuTableView: SettingsMenuTableView!
    var settingsMenuTableViewDataSource: SettingsMenuTableViewDataSource!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUserInterfaceForCurrentUserProfile()
        setUserDataIntoUIComponents()
        setUpSettingsSlideOutMenu()
    }
    
    private func setUpUserInterfaceForCurrentUserProfile() {
        user = UserManager.sharedInstance.currentUser!
        //TODO: dummy current user data for now for CURRENT USER
        user.bio = "I like brownrice"
        user.userName = "@burownrice"
    }
    
    //MARK: RightSideSlideOutSettingsMenu Code
    func settingsButtonPressed() {
        if self.settingsMenuTableView.showing == false {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.settingsMenuTableView.frame = CGRectOffset(self.settingsMenuTableView.frame, -self.view.frame.width*0.9, 0)
                self.blackOverlayLeftView.backgroundColor = UIColor.blackColor()
                self.blackOverlayLeftView.alpha = 0.5
                self.view.addSubview(self.blackOverlayLeftView)
                self.view.addSubview(self.settingsMenuTableView)
                }, completion: { (completed) -> Void in
                    //done
                    self.settingsMenuTableView.showing = true
            })
        } else {
            closeSettingsRightSideMenu()
        }
    }
    
    private func closeSettingsRightSideMenu() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingsMenuTableView.frame = CGRectOffset(self.settingsMenuTableView.frame, self.view.frame.width*0.9, 0)
            self.blackOverlayLeftView.alpha = 0.0
            }, completion: { (completed) -> Void in
                //done
                self.settingsMenuTableView.showing = false
                self.blackOverlayLeftView.removeFromSuperview()
        })
    }
    
    private func setUpSettingsSlideOutMenu() {
        //Settings button only for current user
        let rightSettingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "Btn_Menu_SETTINGS_INACTIVE_05"), style: UIBarButtonItemStyle.Done, target: self, action: "settingsButtonPressed")
        self.navigationItem.rightBarButtonItem = rightSettingsBarButtonItem
        
        self.blackOverlayLeftView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: view.frame.height))
        blackOverlayLeftView.backgroundColor = UIColor.clearColor()
        let tapGesture = UITapGestureRecognizer(target: self, action: "blackOverlayWasTapped")
        blackOverlayLeftView.userInteractionEnabled = true
        blackOverlayLeftView.addGestureRecognizer(tapGesture)
        
        settingsMenuTableView = SettingsMenuTableView(frame: CGRect(x: view.frame.width, y: 66, width: view.frame.width*0.9, height: view.frame.height - (self.navigationController?.navigationBar.frame.size.height)! - self.tabBarController!.tabBar.frame.size.height))
        settingsMenuTableViewDataSource = SettingsMenuTableViewDataSource()
        settingsMenuTableViewDataSource.delegate = self
        settingsMenuTableView.delegate = settingsMenuTableViewDataSource
        settingsMenuTableView.dataSource = settingsMenuTableViewDataSource
        settingsMenuTableView.tableFooterView = UIView(frame: CGRectZero)
        settingsMenuTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        settingsMenuTableView.separatorColor = UIColor(rgba: "#aaaaaa")
    }
    
    @objc
    private func blackOverlayWasTapped() {
        closeSettingsRightSideMenu()
    }
    
}


extension CurrentUserProfileViewController: SettingsMenuTableViewDelegate {
    
    func didPressEditProfile() {
        print("did press EDIT PROFILE")
    }
    
    func didPressMyTastePreferences() {
        print("did press my taste preferences")
    }
    
    func didPressFAQsSupport() {
        print("did press faq support")
    }
    
    func didPressLogOut() {
        print("Did press logout")
        closeSettingsRightSideMenu()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func goBackToLoginScreen() {
        print("going back to login screen")
    }
}

