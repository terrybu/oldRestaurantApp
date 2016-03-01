//
//  FeedViewController.swift
//  Tastii
//
//  Created by Terry Bu on 12/2/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit
import FBSDKLoginKit

enum ShowProfileOption: String {
    case Redeemer = "redeemer"
    case Buddy = "buddy"
}

enum ActivityFeedFilterSelection: Int {
    case OnlyYourActivities = 0
    case YouAndFriendsActivities = 1
    case NearbyActivities = 2
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ActivityCellDesignerDelegate {
    
    @IBOutlet var tableView: UITableView!
    var segmentedControl:UISegmentedControl!
    var allActivitiesArray = [Activity]()
    var onlyYourActivitiesArray: [Activity]?
    let activityCellDesigner = ActivityCellDesigner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        insertSegmentedControlInsideNavigationBar()
        tableView.registerNib(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityTableViewCell")
        fillUpDummyActivityData()
        activityCellDesigner.delegate = self
        onlyYourActivitiesArray = allActivitiesArray.filter({ (activity) -> Bool in
            return activity.user.firstName == "Miasha" && activity.user.lastName == "Vicino"
        })
        
        //this below line allows the fixing of a weird black navigation bar glitch that stays in place after you try to navigate away
        self.navigationController!.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        //this is to make sure status bar is white here, and then next page, it becomes black on user profile and then coming back
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.hidden = false
    }
    
    private func insertSegmentedControlInsideNavigationBar() {
        let feedFilterYouImage = UIImage(named: "Btn_ActivityFeed_YOU_INACTIVE_01")!
        let feedFilterFriendsImage = UIImage(named: "Btn_ActivityFeed_FRIENDS_INACTIVE_03")!
        let feedFilterNearByImage = UIImage(named: "Btn_ActivityFeed_NEARYOU_INACTIVE_05")!
        
        segmentedControl = UISegmentedControl(items: [feedFilterYouImage, feedFilterFriendsImage, feedFilterNearByImage])
        segmentedControl.frame.size.width = (self.navigationController?.navigationBar.frame.size.width)! * 0.60
        segmentedControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self, action: "segmentedControlValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    private func fillUpDummyActivityData() {
        let miasha = User(firstName: "Miasha", lastName: "Vicino", imageName: "miashaFace")
        miasha.userId = "d740de32-7dbc-d0cd-083f-56aff004dbea"
        miasha.imageURLString = "http://tastii.fifthq.com/media/f/d/2/0/3/d/orig_d740de32-7dbc-d0cd-083f-56aff004dbea.png"
        miasha.followers = 102
        miasha.following = 23
        miasha.bio = "I am Miasha and I'm awesome"
        miasha.userName = "@MooshMoosh"
        
        let pestoPasta = Item(name: "Gluten Free Pesto Pasta", imageName: "pestoPasta")
        let sampleAct1 = TastiingRedeemActivity(user: miasha, item: pestoPasta)
        allActivitiesArray.append(sampleAct1)
        miasha.activitiesArray = [sampleAct1]
        
        let jd = User(firstName: "JD", lastName: "REcobs", imageName: "jdFace")
        jd.followers = 233
        let wineTasting = Item(name: "Wine Tasting", imageName: "wineTasting")
        let sampleActivity2 = TasteMatchAddActivity(user: jd, item: wineTasting)
        allActivitiesArray.append(sampleActivity2)
        let sampleActivity2b = TastiingRedeemActivity(user: jd, item: pestoPasta, redeemBuddies: [miasha])
        jd.activitiesArray = [sampleActivity2, sampleActivity2b]
        
        let josh = User(firstName: "Josh", lastName: "Roenitz", imageName: "joshFace")
        josh.followers = 333
        let burger = Item(name: "Avocado Burger and Sweet Potato Fries", imageName: "burger")
        let sampleActivity3 = TasteMatchAddActivity(user: josh, item: burger)
        allActivitiesArray.append(sampleActivity3)
        josh.activitiesArray = [sampleActivity3]
        
        let terry = User(firstName: "Terry", lastName: "Bu", imageName: "terryFace")
        terry.followers = 666
        let sampleActivity4 = TastiingRedeemActivity(user: terry, item: Item(name: "Dragon Roll", imageName: "dragonRoll"))
        let jack = User(firstName: "Jack", lastName: "Dorsay", imageName: "jackFace")
        sampleActivity4.redeemBuddies = [jack]
        allActivitiesArray.append(sampleActivity4)
        terry.activitiesArray = [sampleActivity4]
    }
    
    
    //MARK: TableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == ActivityFeedFilterSelection.OnlyYourActivities.rawValue {
            return onlyYourActivitiesArray!.count
        }
        return allActivitiesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityTableViewCell", forIndexPath: indexPath) as! ActivityTableViewCell
        
        var currentActivity: Activity?
        
        if segmentedControl.selectedSegmentIndex == ActivityFeedFilterSelection.OnlyYourActivities.rawValue {
            currentActivity = onlyYourActivitiesArray![indexPath.row]
        } else {
            currentActivity = allActivitiesArray[indexPath.row]
        }
        
        activityCellDesigner.setUpActionableTextWithinTextView(currentActivity!, cell: cell, indexPath: indexPath)
        activityCellDesigner.setUpLeftUserProfileCircleImageView(currentActivity!, cell: cell, indexPath: indexPath)
        
        cell.activityTimeCreatedLabel.text = "10 mins"
        cell.rightTasteItemImageView.image = UIImage(named: currentActivity!.item.imageName!)
        cell.rightTasteItemImageView.layer.cornerRadius = 2.5
        cell.rightTasteItemImageView.clipsToBounds = true
        
        return cell
    }
    
    //MARK: TableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: ActivityCellDesignerDelegate
    func didDetectUserCircleImageViewPress(indexPath: Int) {
        let user = allActivitiesArray[indexPath].user
        createAndPushProfileViewController(user)
    }
    
    func didDetectBuddyCircleImageViewPress(indexPath: Int) {
        let activity = allActivitiesArray[indexPath] as! TastiingRedeemActivity
        let user = activity.redeemBuddies![0]
        createAndPushProfileViewController(user)
    }
    
    func createAndPushProfileViewController(user: User) {
        let otherUserProfileVC = OtherUserProfileViewController()
        otherUserProfileVC.user = user
        self.navigationController?.pushViewController(otherUserProfileVC, animated: true)
    }
    
    func didDetectTextViewNamePress(option: ShowProfileOption, indexPath: Int) {
        let otherUserProfileVC = OtherUserProfileViewController()
        if option == ShowProfileOption.Redeemer {
            let activity = allActivitiesArray[indexPath]
            otherUserProfileVC.user = activity.user
        } else if option == ShowProfileOption.Buddy {
            let redeemActivity = allActivitiesArray[indexPath] as! TastiingRedeemActivity
            otherUserProfileVC.user = redeemActivity.redeemBuddies![0]
        }
        self.navigationController?.pushViewController(otherUserProfileVC, animated: true)
    }
    
    //MARK: IBActions
    func segmentedControlValueChanged(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case ActivityFeedFilterSelection.OnlyYourActivities.rawValue:
            print("your activity")
            tableView.reloadData()
            break
        case ActivityFeedFilterSelection.YouAndFriendsActivities.rawValue:
            print("activity from you AND people you are following")
            tableView.reloadData()
            break
        case ActivityFeedFilterSelection.NearbyActivities.rawValue:
            print("nearby activity based on geolocation")
            break
        default:
            break
        }
    }
    
    
    
    
}