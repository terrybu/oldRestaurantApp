//
//  UserProfileViewController.swift
//  Tastii
//
//  Created by Terry Bu on 2/10/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController{
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
    @IBOutlet weak var followingNumLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myMenusLabel: UILabel!
    @IBOutlet weak var addMenuButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    var blackOverlayLeftView: UIView!
    var settingsMenuTableView: SettingsMenuTableView!
    var settingsMenuTableViewDataSource: SettingsMenuTableViewDataSource!
    
    var user: User!
    var showingLoggedInUser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont(name: "Arial", size: 21)!]
        backgroundImageView.image = UIImage(named: "Img_login_Background")
        profileImageView.circleImageViewSetUp(UIColor.whiteColor())
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        setUpSettingsSlideOutMenu()
        tableView.registerNib(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "UserProfileTableViewCellIdentifier")
        collectionView.registerNib(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionViewCell")
        
        setUpUserSpecificUIComponents()
    }
    
    private func setUpUserSpecificUIComponents() {
        if showingLoggedInUser {
            setUpUserInterfaceForCurrentUserProfile()
        } else {
            //if it's not current user 
            myMenusLabel.text = "\(user.firstName)'s Menus"
            addMenuButton.hidden = true
        }
        self.title = "\(user.firstName) \(user.lastName)"
        let tastiitabbarVC = self.tabBarController as! TastiiTabBarViewController
        tastiitabbarVC.removeTabbarItemText()
        
        followersNumLabel.text = "\(user.followers)"
        followingNumLabel.text = "\(user.following)"
        usernameLabel.text = user.userName
        bioLabel.text = user.bio
        if let imageURLString = user.imageURLString {
            profileImageView.af_setImageWithURL(NSURL(string: imageURLString)!, placeholderImage: placeholderImage, filter: nil, imageTransition: UIImageView.ImageTransition.CrossDissolve(0.5))
        }
    }
    
    private func setUpUserInterfaceForCurrentUserProfile() {
        user = UserManager.sharedInstance.currentUser!
        //TODO: dummy current user data for now for CURRENT USER
        user.bio = "I like brownrice"
        user.userName = "@burownrice"
        //Settings button only for current user
        let rightSettingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "Btn_Menu_SETTINGS_INACTIVE_05"), style: UIBarButtonItemStyle.Done, target: self, action: "settingsButtonPressed")
        self.navigationItem.rightBarButtonItem = rightSettingsBarButtonItem
    }
    
    override func viewDidAppear(animated: Bool) {
        //you need this because by default, we just have collectionview height as 400. By doing this, collectionView will resize its height according to content size and how many cells there are. 
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
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
        self.blackOverlayLeftView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: view.frame.height))
        blackOverlayLeftView.backgroundColor = UIColor.clearColor()
        let tapGesture = UITapGestureRecognizer(target: self, action: "blackOverlayWasTapped")
        blackOverlayLeftView.userInteractionEnabled = true
        blackOverlayLeftView.addGestureRecognizer(tapGesture)
        
        settingsMenuTableView = SettingsMenuTableView(frame: CGRect(x: view.frame.width, y: 0, width: view.frame.width*0.9, height: view.frame.height - self.tabBarController!.tabBar.frame.size.height))
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserProfileTableViewCellIdentifier", forIndexPath: indexPath) as! UserProfileTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.wantOrLoveLabel.text = "Want it"
        cell.statNumLabel.text = "100"
        return cell
    }
}

extension UserProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuCollectionViewCell", forIndexPath: indexPath)
        
        let foodieCategoryImage = UIImage(named: "NewFoodieCategories-1")
        let imageView = UIImageView(image: foodieCategoryImage)
        imageView.contentMode = .ScaleToFill
        cell.backgroundView = imageView
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let size = collectionView.frame.size.width/3-10
        return CGSize(width: size, height: size)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
}

extension UserProfileViewController: SettingsMenuTableViewDelegate {
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
        print("did press log Out")
    }
    
    func goBackToLoginScreen() {
        print("going back to login screen")
    }
}

