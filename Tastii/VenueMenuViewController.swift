//
//  VenueMenuViewController.swift
//  Tastii
//
//  Created by Terry Bu on 1/27/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit
import MBProgressHUD

class VenueMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var venue: Venue!
    var menuSectionsArray: [MenuSection]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = venue.name
        
        let venueDetailsDisclosureButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "openVenueDetailView")
        self.navigationItem.rightBarButtonItem = venueDetailsDisclosureButton
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Loading Restaurant Items ..."
        APIDataQuery.sharedInstance.getItemsForVenue(venue.id!) { (success, menuSectionsArray) -> Void in
            if success {
                self.menuSectionsArray = menuSectionsArray
                self.tableView.reloadData()
            } else {
                UIAlertController.presentAlert(self, alertTitle: "Data Not Found", alertMessage: "This restaurant does not have any items available on our server yet.", confirmTitle: "OK")
            }
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
        
        tableView.registerNib(UINib(nibName: "VenueMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "VenueMenuTableViewCell")
    }
    
    func openVenueDetailView() {
        print("open venue detail view")
        let venueDetailVC = VenueDetailViewController()
        venueDetailVC.venue = venue
        navigationController?.pushViewController(venueDetailVC, animated: true)
    }
    
    //MARK: TableViewDataSource Protocol Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let menuSectionsArray = menuSectionsArray {
            return menuSectionsArray.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionObject = menuSectionsArray![section]
        return sectionObject.name
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        view.tintColor = UIColor.lightGrayColor()
        header.textLabel!.textColor = UIColor.blackColor()
//        header.textLabel!.font = UIFont.boldSystemFontOfSize(25)
        header.textLabel!.frame = header.frame
        header.textLabel!.textAlignment = NSTextAlignment.Center
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let menuSectionsArray = menuSectionsArray {
            let sectionObject = menuSectionsArray[section]
            return sectionObject.items.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VenueMenuTableViewCell", forIndexPath: indexPath) as! VenueMenuTableViewCell
        let menuSection = menuSectionsArray![indexPath.section]
        let item = menuSection.items[indexPath.row]
        cell.menuItemNameLabel.text = item.name
        cell.menuItemDescriptionLabel.text = item.description
        cell.menuItemPriceDistanceLabel.text = "$\(item.price!) - 0.3 mi"
//        matchingUsersLogic(cell, item: item)
        cell.itemsDetailsButton.tag = indexPath.row
        cell.itemsDetailsButton.addTarget(self, action: "itemsDetailButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    @objc
    private func itemsDetailButtonPressed(sender: UIButton) {
//        let menuSection = menuSectionsArray![indexPath.section]
//        let item = menuSection.items[indexPath.row]
        //TODO: We need logic here, either subclass this UIBUTTON to include "section" as a property
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let wannaTry = UIAlertAction(title: "Want to Try", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("Want to try")
        }
        let addToMenu = UIAlertAction(title: "Add to a Menu", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("Add to a menu")
        }
        let markAsTastii = UIAlertAction(title: "Mark as Tastii", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("Mark as Tastii")
        }
        let share = UIAlertAction(title: "Share", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("Share")
        }
        let venueInfo = UIAlertAction(title: "Venue Info", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("Venue Info")
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(wannaTry)
        alertController.addAction(addToMenu)
        alertController.addAction(markAsTastii)
        alertController.addAction(share)
        alertController.addAction(venueInfo)
        alertController.addAction(cancel)
        alertController.view.tintColor = UIColor.blackColor()
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
//    private func matchingUsersLogic(cell: VenueMenuTableViewCell, item: Item) {
//        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//        activityIndicator.center = view.center
//        view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
//        
//        cell.firstCircleImageView.hidden = true
//        cell.secondCircleImageView.hidden = true
//        cell.thirdCircleImageView.hidden = true
//        
//        let currentUser = UserManager.sharedInstance.currentUser!
//        APIDataQuery.sharedInstance.getMatchedUsers(item) { (success, totalNumberOfMatches, matchedUsers) -> Void in
//            //completion block
//            if (success) {
//                item.numberOfMatchedUsers = totalNumberOfMatches
//                item.matchedUsersToShow = matchedUsers
//            } else {
//                item.numberOfMatchedUsers = 0
//                item.matchedUsersToShow = nil
//            }
//            switch (item.numberOfMatchedUsers) {
//            case 0:
//                break
//            case 1:
//                cell.firstCircleImageView.hidden = true
//                self.unhideAndDisplayCurrentUserProfilePicIfExists(matchedUsers![0], imageView: cell.secondCircleImageView)
//                cell.thirdCircleImageView.hidden = true
//                break
//            case 2:
//                self.unhideAndDisplayCurrentUserProfilePicIfExists(matchedUsers![0], imageView: cell.firstCircleImageView)
//                //TODO: we need some logic here that puts the CURRENT USER into the first circle image view slot if it detects that it is a match.
//                self.unhideAndDisplayCurrentUserProfilePicIfExists(matchedUsers![1], imageView: cell.secondCircleImageView)
//                cell.thirdCircleImageView.hidden = false
//                cell.thirdCircleImageView.image = nil
//                cell.thirdCircleImageView.layer.borderColor = UIColor.grayColor().CGColor
//                break
//            case 3:
//                //
//                break
//            default:
//                self.unhideAndDisplayCurrentUserProfilePicIfExists(matchedUsers![0], imageView: cell.firstCircleImageView)
//                let matchedUser1 = matchedUsers![1] as User
//                self.unhideAndDisplayCurrentUserProfilePicIfExists(matchedUser1, imageView: cell.secondCircleImageView)
//                let matchedUser2 = matchedUsers![2] as User
//                self.unhideAndDisplayCurrentUserProfilePicIfExists(matchedUser2, imageView: cell.thirdCircleImageView)
//                break
//            }
//        }
//        
//        APIDataQuery.sharedInstance.getMatchObjectForItemForCurrentUser(item, completion: { (success, objectIsMatch, matchID) -> Void in
//            if let objectIsMatch = objectIsMatch {
//                if success && objectIsMatch {
//                    print("turning on switch for \(item.name) because it's match")
//                    cell.matchSwitch.setOn(true, animated: false)
//                } else if success && objectIsMatch == false {
//                    print("Keep the switch turned off for \(item.name) because we determined it's not a match")
//                }
//            } else {
//                cell.matchSwitch.setOn(false, animated: false)
//            }
//            activityIndicator.stopAnimating()
//            }
//        )
//        cell.matchSwitch.addTarget(self, action: "matchSwitchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
//    }
    
    private func unhideAndDisplayCurrentUserProfilePicIfExists(currentUser: User, imageView: UIImageView) {
        imageView.hidden = false
        if let imageURL = currentUser.imageURLString {
            imageView.af_setImageWithURL(NSURL(string: imageURL)!, placeholderImage: placeholderImage, filter: nil, imageTransition: UIImageView.ImageTransition.CrossDissolve(0.5))
        } else {
            imageView.image = placeholderImage
        }
    }

    
    //MARK: TableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
}
