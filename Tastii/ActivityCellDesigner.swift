//
//  ActivityCellDesigner.swift
//  Tastii
//
//  Created by Terry Bu on 12/21/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit

protocol ActivityCellDesignerDelegate {
    
    func didDetectTextViewNamePress(option: ShowProfileOption, indexPath: Int)
    func didDetectUserCircleImageViewPress(indexPath: Int)
    func didDetectBuddyCircleImageViewPress(indexPath: Int)
}

class ActivityCellDesigner {
    
    var delegate: ActivityCellDesignerDelegate?
    
    //MARK: Actionable TextView Related
    func setUpActionableTextWithinTextView(activity: Activity, cell: ActivityTableViewCell,  indexPath: NSIndexPath) {
        let fullName = "\(activity.user.firstName) \(activity.user.lastName)"
        var messageString: NSMutableAttributedString
        switch activity {
        case let tasteMatchAddActivity as TasteMatchAddActivity:
            messageString = NSMutableAttributedString(string: "\(fullName) added \(tasteMatchAddActivity.item.name) to Taste Matches.")
        case let tastiingRedeemActivity as TastiingRedeemActivity:
            if let buddies = tastiingRedeemActivity.redeemBuddies {
                let buddy = buddies[0]
                let buddyName = "\(buddy.firstName) \(buddy.lastName)"
                messageString = NSMutableAttributedString(string:"\(fullName) and \(buddyName) redeemed \(tastiingRedeemActivity.item.name).")
            } else {
                messageString = NSMutableAttributedString(string:"\(fullName) redeemed \(tastiingRedeemActivity.item.name).")
            }
        default:
            messageString = NSMutableAttributedString()
        }
        
        let userNameRange = NSRange(location: 0, length: fullName.characters.count)
        messageString.addAttribute(NSFontAttributeName, value: UIFont(name: "SFUIDisplay-Bold", size: 14.0)!, range: userNameRange)
        let restOfSentenceRange = NSRange(location: fullName.characters.count, length: fullName.characters.count)
        messageString.addAttribute(NSFontAttributeName, value: UIFont(name:"SFUIDisplay-Regular", size: 14.0)!, range: restOfSentenceRange)
        if activity is TastiingRedeemActivity {
            let redeemActivity = activity as! TastiingRedeemActivity
            if redeemActivity.redeemBuddies != nil {
                setUpBoldFontAndTapGesturesForBuddyRedeemScenario(messageString, redeemActivitiy: redeemActivity)
            }
        }
        
        let customAttribute = [ kCustomAttributeShowProfileOptionKey: ShowProfileOption.Redeemer.rawValue]
        messageString.addAttributes(customAttribute, range: userNameRange)
        cell.activityMessageTextView.attributedText = messageString
        let tap = UITapGestureRecognizer(target: self, action: Selector("userNameWasTappedInsideTextView:"))
        cell.activityMessageTextView.addGestureRecognizer(tap)
        cell.activityMessageTextView.tag = indexPath.row
        cell.activityMessageTextView.textContainerInset = UIEdgeInsetsZero;
    }
    
    private func setUpBoldFontAndTapGesturesForBuddyRedeemScenario(mutableAttributedString: NSMutableAttributedString, redeemActivitiy: TastiingRedeemActivity) {
        let rangeForBuddyName = NSRange(location: redeemActivitiy.user.firstName.characters.count + redeemActivitiy.user.lastName.characters.count + 5, length: redeemActivitiy.redeemBuddies![0].firstName.characters.count + redeemActivitiy.redeemBuddies![0].lastName.characters.count )
        mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "SFUIDisplay-Bold", size: 14.0)!, range: rangeForBuddyName)
        let customAttribute = [ kCustomAttributeShowProfileOptionKey: ShowProfileOption.Buddy.rawValue]
        mutableAttributedString.addAttributes(customAttribute, range: rangeForBuddyName)
    }
    
    
    @objc
    private func userNameWasTappedInsideTextView(sender: UITapGestureRecognizer) {
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.locationInView(myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        // character index at tap location
        let characterIndex = layoutManager.characterIndexForPoint(location, inTextContainer: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
            let attributeValue = myTextView.attributedText.attribute(kCustomAttributeShowProfileOptionKey, atIndex: characterIndex, effectiveRange: nil) as? String
            if let value = attributeValue {
                if value == ShowProfileOption.Redeemer.rawValue {
                    self.delegate?.didDetectTextViewNamePress(ShowProfileOption.Redeemer, indexPath: sender.view!.tag)
                } else if value == ShowProfileOption.Buddy.rawValue {
                    self.delegate?.didDetectTextViewNamePress(ShowProfileOption.Buddy, indexPath: sender.view!.tag)
                }
            }
        }
    }
    
    //MARK: Circle Image View Related
    func setUpLeftUserProfileCircleImageView(currentActivity: Activity, cell: ActivityTableViewCell, indexPath: NSIndexPath) {
        if currentActivity is TastiingRedeemActivity {
            let activity = currentActivity as! TastiingRedeemActivity
            if let buddies = activity.redeemBuddies, redeemBuddies = activity.redeemBuddies {
                var userProfileImage: UIImage
                if let imageName = activity.user.imageName {
                    userProfileImage = UIImage(named: imageName)!
                } else {
                    userProfileImage = UIImage(named: kImageNoProfilePicAvatarName)!
                }
                let userCircleImageView = UIImageView(image: userProfileImage)
                userCircleImageView.frame = CGRectMake(0, 0, 30, 30)
                userCircleImageView.layer.cornerRadius = userCircleImageView.frame.size.height/2
                userCircleImageView.clipsToBounds = true
                setViewClickableToProfile(userCircleImageView, indexPath: indexPath, action: "userFaceTapped:")
                cell.leftContainerView.addSubview(userCircleImageView)
                let buddy = buddies[0]
                let buddyCircleImageView = UIImageView(image:UIImage(named: redeemBuddies[0].imageName!))
                buddyCircleImageView.frame = CGRectMake(15, 15, 30, 30)
                buddyCircleImageView.layer.cornerRadius = userCircleImageView.frame.size.height/2
                buddyCircleImageView.clipsToBounds = true
                setViewClickableToProfile(buddyCircleImageView, indexPath: indexPath, action: "buddyFaceTapped:")
                cell.leftContainerView.addSubview(buddyCircleImageView)
            } else {
                createImageViewForUserFaceImage(currentActivity, cell: cell, indexPath: indexPath)
            }
        } else {
            createImageViewForUserFaceImage(currentActivity, cell: cell, indexPath: indexPath)
        }
    }
    
    private func createImageViewForUserFaceImage(currentActivity: Activity, cell: ActivityTableViewCell, indexPath: NSIndexPath) {
        if cell.leftContainerView.subviews.count == 0 {
            var image:UIImage
            if let imageName = currentActivity.user.imageName {
                image = UIImage(named: imageName)!
            } else {
                image = UIImage(named: kImageNoProfilePicAvatarName)!
            }
            let leftCircleImageView = UIImageView(image:image)
            leftCircleImageView.frame = CGRectMake(0, 0, 45, 45)
            leftCircleImageView.layer.cornerRadius = leftCircleImageView.frame.size.height/2
            leftCircleImageView.clipsToBounds = true
            cell.leftContainerView.addSubview(leftCircleImageView)
            setViewClickableToProfile(leftCircleImageView, indexPath: indexPath, action: "userFaceTapped:")
        }
    }
    
    //MARK: Circular User Image Tap Gesture Related Functions
    private func setViewClickableToProfile(view: UIView, indexPath: NSIndexPath, action: Selector) {
        view.userInteractionEnabled = true
        view.tag = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func userFaceTapped(sender: UITapGestureRecognizer) {
        delegate?.didDetectUserCircleImageViewPress(sender.view!.tag)
    }
    
    @objc
    private func buddyFaceTapped(sender: UITapGestureRecognizer) {
        delegate?.didDetectBuddyCircleImageViewPress(sender.view!.tag)
    }
    


    
}