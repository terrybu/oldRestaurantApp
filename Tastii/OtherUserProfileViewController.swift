//
//  OtherUserProfileViewController.swift
//  Tastii
//
//  Created by Terry Bu on 2/23/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

class OtherUserProfileViewController: ProfileParentViewController, UIActionSheetDelegate{
    
    @IBOutlet var followButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserDataIntoUIComponents()
        let detailsButton = UIBarButtonItem(image: UIImage(named: "Btn_MyList_DETAILSINCIRCLE_01"), style: UIBarButtonItemStyle.Done, target: self, action: "detailsButtonPressed:")
        self.navigationItem.rightBarButtonItem = detailsButton
        print(detailsButton)
    }
    
    func detailsButtonPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let followUser = UIAlertAction(title: "Follow User", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            //TODO: this title needs to match the FOLLOW UNFOLLOW status. we need logic behind that ... CHECK if this user is followed
            print("follow user")
        }
        let blockUser = UIAlertAction(title: "Block User", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            //some code for followerUser
            print("block user")
        }
        let reportproblem = UIAlertAction(title: "Report a Problem", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            //some code for followerUser
            print("Report a problem")
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(followUser)
        alertController.addAction(blockUser)
        alertController.addAction(reportproblem)
        alertController.addAction(cancel)
        alertController.view.tintColor = UIColor.blackColor()
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func followButtonPressed(sender: UIButton) {
        print("button pressed")
        if sender.titleLabel!.text == "Follow" {
            APIDataQuery.sharedInstance.followOrUnfollowUser(user.userId!, follow: true) { (success) -> Void in
                if success {
                    print("success follow")
                    sender.setTitle("Unfollow", forState: UIControlState.Normal)
                }
            }
        } else if sender.titleLabel!.text == "Unfollow" {
            APIDataQuery.sharedInstance.followOrUnfollowUser(user.userId!, follow: false) { (success) -> Void in
                if success {
                    print("success unfollow")
                    sender.setTitle("Follow", forState: UIControlState.Normal)
                }
            }
        }
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
