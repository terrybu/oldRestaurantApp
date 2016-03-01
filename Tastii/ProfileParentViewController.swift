//
//  ProfileParentViewController.swift
//  Tastii
//
//  Created by Terry Bu on 2/23/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

class ProfileParentViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
    @IBOutlet weak var followingNumLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont(name: "Arial", size: 21)!]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.translucent = true

        backgroundImageView.image = UIImage(named: "Img_login_Background")
        profileImageView.circleImageViewSetUp(UIColor.whiteColor())
        tableView.registerNib(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "UserProfileTableViewCellIdentifier")
        collectionView.registerNib(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionViewCell")
    }
    
    func setUserDataIntoUIComponents() {
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
    
    override func viewDidAppear(animated: Bool) {
        //you need this because by default, we just have collectionview height as 400. By doing this, collectionView will resize its height according to content size and how many cells there are.
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ProfileParentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserProfileTableViewCellIdentifier", forIndexPath: indexPath) as! UserProfileTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        if indexPath.row == 0 {
            cell.wantOrLoveLabel.text = "Want it"
        } else {
            cell.wantOrLoveLabel.text = "Love it"
        }
        cell.statNumLabel.text = "100"
        return cell
    }
}

extension ProfileParentViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
